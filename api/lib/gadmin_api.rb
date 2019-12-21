require 'google/apis/admin_directory_v1'
require 'googleauth'

class GCPAdminDirectory
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

    def join_group(group_name, user_mail)
        group = @service.list_groups(domain: @domain, query: "email:" + group_name}.groups.first
        @service.list_members(group.email).members.each{|m|puts m.email}.first

        member = @service.list_users(domain: @domain, query: "email:" + user_mail).users.first
        @service.insert_member(group.email, member)
    end

    def leave_group(group_name, user_mail)
        group = @service.list_groups(domain: @domain, query: "email:" + group_name}.groups.first
        member = @service.list_users(domain: @domain, query: "email:" + user_mail).users.first
        @service.delete_member(group.email, member.id)
    end

    def list_groups_all()
        @service.list_groups(domain: @domain).groups.map{|g| g.email}
    end

    def list_groups()
        @service.list_groups(domain: @domain, user_key: member.id).groups
    end
end