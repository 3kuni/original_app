require 'open-uri'
require 'json'

class Todoist
    API_URL = 'https://todoist.com/API/v6/sync'
    TOKEN = 'be2b6e8e5c628456003670f8f9e53c4583593904'

    def self.getAllCompletedItems(project_id)
        request_url = create_url('getAllCompletedItems', {:token => TOKEN, :project_id => project_id})
        api_request(request_url)
    end

    def getUncompletedItems(project_id)
        request_url = create_url('getUncompletedItems', {:token => TOKEN, :project_id => project_id})
        api_request(request_url)
    end

    def api_request(request_url)
        res = open(request_url)
        code, message = res.status

        if code == '200'
            return JSON.parse(res.read)
        end
    end

    def create_url(action, params)
        API_URL + action + '?' + URI.encode_www_form(params) 
    end

end