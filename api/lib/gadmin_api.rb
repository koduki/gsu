require 'google/apis/admin_directory_v1'
require "google/cloud/tasks"
require 'googleauth'

class GCPAdminAPI
    def initialize
        scope = [ 
            'https://www.googleapis.com/auth/admin.directory.group.readonly', 
            'https://www.googleapis.com/auth/admin.directory.group.member', 
            'https://www.googleapis.com/auth/admin.directory.user.readonly' 
        ]

        @domain = ENV['GCP_DOMAIN']
        @service = Google::Apis::AdminDirectoryV1::DirectoryService.new
        authorization = Google::Auth.get_application_default(scope).dup
        authorization.sub = ENV["GCP_ADMIN_USER"]
        @service.authorization = authorization    
    end

    def attach_group(user_name, group_name)
        member = @service.list_users(domain: @domain, query: "email:" + user_name).users.first

        @service.insert_member(group_name, member)
    end

    def detach_group(user_name, group_name)
        @service.delete_member(group_name, user_name)
    end

    def list_groups_all()
        @service.list_groups(domain: @domain).groups.map{|g| g.email}
    end

    def list_groups(user_name)
        @service.list_groups(domain: @domain, user_key: user_name)
                .groups
                .map{|g| g.email}
    end

    def healthcheck()
        @service.list_groups(domain: @domain).groups
        @service.list_users(domain: @domain).users
    end

    def set_expire(seconds)
        gcp_prj = ENV["GCP_PROJECT"]
        q_location = ENV["GCP_Q_LOCATION"]
        q_name = ENV["GCP_Q_NAME"]
        service_account = ENV["GSU_SRC_ACCOUNT"]
        api_url = ENV["GSU_API_URL"]

        client = Google::Cloud::Tasks.cloud_tasks
        parent = client.queue_path project: gcp_prj, location: q_location, queue: q_name
        task = {
            http_request: {
            http_method: "POST",
            oidc_token: {"service_account_email": service_account},
            url: "#{api_url}/detach/koduki-user/group-viewer"
            }
        }

        # Add scheduled time to task.
        if seconds
            timestamp = Google::Protobuf::Timestamp.new
            timestamp.seconds = Time.now.to_i + seconds.to_i
            task[:schedule_time] = timestamp
        end

        # Send create task request.
        puts "Sending task #{task}"

        response = client.create_task parent: parent, task: task

        puts "Created task #{response.name}" if response.name

    end

    def clear_privileges(user_name)
        admins = @service.list_groups(domain: @domain, user_key: user_name).groups
            .find_all{|x| x.email.include?("-admin@")}
        admins.each{|g| @service.delete_member(g.email, user_name) }
    end
end