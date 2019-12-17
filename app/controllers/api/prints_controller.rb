module Api
  class PrintsController < ApiController

    def show
      @policy = Policy.find(params[:id])
      respond_to do |format|
        format.json
        format.pdf do
          render pdf: 'policy', layout: 'layouts/pdf.haml', template: 'api/prints/show.pdf.haml', dpi: 300, show_as_html: params.key?('debug'), javascript_delay: 3000, margin: {top: 10, bottom: 20, left: 15, right: 15 }, outline: {outline: true, outline_depth: 10 }, footer: {html: {template:'shared/_pdf_footer'}}
        end
      end
    end
  end
end
