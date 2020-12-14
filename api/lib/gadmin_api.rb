require 'google/apis/admin_directory_v1'
require 'googleauth'

class GCPAdminAPI
    def initialize
        scope = [ 
            'https://www.googleapis.com/auth/admin.directory.group.readonly', 
            'https://www.googleapis.com/auth/admin.directory.group.member', 
            'https://www.googleapis.com/auth/admin.directory.user.readonly' 
        ]

        ENV['GOOGLE_APPLICATION_CREDENTIALS'] = ENV['SA_KEY'] if ENV['SA_KEY']

        @domain = ENV['GCP_DOMAIN']
        @service = Google::Apis::AdminDirectoryV1::DirectoryService.new
        authorization = Google::Auth.get_application_default(scope).dup
        authorization.sub = ENV["GCP_ADMIN_USER"]
        @service.authorization = authorization    
    end

    def attach_group(user_name, group_name)
        member = @service.list_users(domain: @domain, query: "email:" + user_name).users.first

        clear_privileges(user_name)
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

    def clear_privileges(user_name)
        admins = @service.list_groups(domain: @domain, user_key: user_name).groups
            .find_all{|x| x.email.include?("-admin@")}
        admins.each{|g| @service.delete_member(g.email, user_name) }
    end
end