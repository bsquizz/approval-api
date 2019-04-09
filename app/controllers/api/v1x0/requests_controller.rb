module Api
  module V1x0
    class RequestsController < ApplicationController
      include Mixins::IndexMixin

      def create
        req = RequestCreateService.new(params.require(:workflow_id)).create(request_params)
        json_response(req, :created)
      end

      def show
        req = Request.find(params.require(:id))
        json_response(req)
      end

      def index
        if params[:workflow_id]
          workflow = Workflow.find(params.require(:workflow_id))
          collection(workflow.requests)
        else
          reqs = Request.filter(params.slice(:requester, :decision, :state))
          collection(reqs)
        end
      end

      private

      def request_params
        params.permit(:name, :requester, :content => {})
      end
    end
  end
end
