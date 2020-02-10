module Api
  class BusinessProcessesController < ApiController
    def import
      BusinessProcess.import(params[:file])
    end
  end
end