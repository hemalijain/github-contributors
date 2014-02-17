require 'github_api'

module Github
  module Contributors   
    class Github::Contributors::List
      attr_reader :connection,:path,:current_user
      def initialize connection,path,current_user, options = {}
        @current_user=current_user
        @path = path
        @connection = connection
        find_list_of_orgs
      end

      def find_list_of_orgs
        @repos_org=Array.new()
        @repos_ind=Array.new()
        @matched=Array.new()
        @orgs=@connection.orgs.list.map(&:login)
        @orgs.each do |org|
          self.find_repo_of_org(org)
        end
      end

      def find_repo_of_org(org)
        @repos_org.push(@connection.repos.list(auto_pagination: true,user:org).map(&:name))
        @repos_org.each do |repos|
          repos.each do |repo|
            @contri=self.find_contributors(org,repo)
          end
        end
      end

      def find_contributors(org,repo)
        @repos_indi=@connection.repos.contributors(auto_pagination: true,repo:repo,anon:1,user:org).map(&:login) rescue []
        if @repos_indi.include? @current_user
          combo=org+"/"+repo
          @repos_ind.push(combo)
        end
      @arry=@repos_ind.flatten
      @new_new_arry=@arry.compact
      end
    end
  end
end
