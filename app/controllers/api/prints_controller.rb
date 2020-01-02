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

    def test_excel
      @policies = Policy.all
      respond_to do |format|
        format.json
        format.pdf do
          render pdf: 'test_excel', layout: 'layouts/pdf.haml', template: 'api/prints/show.pdf.haml', dpi: 300, show_as_html: params.key?('debug'), javascript_delay: 3000, margin: {top: 10, bottom: 20, left: 15, right: 15 }, outline: {outline: true, outline_depth: 10 }, footer: {html: {template:'shared/_pdf_footer'}}
        end
        format.html
        format.xlsx
      end
    end

    def report_policy
      @policy = Policy.find(params[:id])
      respond_to do |format|
        format.json
        format.pdf do
          render pdf: 'report_policy', layout: 'layouts/pdf.haml', template: 'api/prints/report_policy.pdf.haml', dpi: 300, show_as_html: params.key?('debug'), javascript_delay: 3000, margin: {top: 10, bottom: 20, left: 15, right: 15 }, outline: {outline: true, outline_depth: 10 }, footer: {html: {template:'shared/_pdf_footer'}}
        end
        format.xlsx
      end
    end

    def risk
      @risk = Risk.find(params[:id])
      respond_to do |format|
        format.json
        format.pdf do
          render pdf: 'risk', layout: 'layouts/pdf.haml', template: 'api/prints/risk.pdf.haml', dpi: 300, show_as_html: params.key?('debug'), javascript_delay: 3000, margin: {top: 10, bottom: 20, left: 15, right: 15 }, outline: {outline: true, outline_depth: 10 }, footer: {html: {template:'shared/_pdf_footer'}}
        end
      end
    end

    def report
      @policy = Policy.find(params[:id])
      respond_to do |format|
        format.json
        format.pdf do
          render pdf: 'report', layout: 'layouts/pdf.haml', template: 'api/prints/report.pdf.haml', dpi: 300, show_as_html: params.key?('debug'), javascript_delay: 3000, margin: {top: 10, bottom: 20, left: 15, right: 15 }, outline: {outline: true, outline_depth: 10 }, footer: {html: {template:'shared/_pdf_footer'}}
        end
        format.xlsx
      end
    end

    def control
      @control = Control.find(params[:id])
      respond_to do |format|
        format.json
        format.pdf do
          render pdf: 'control', layout: 'layouts/pdf.haml', template: 'api/prints/control.pdf.haml', dpi: 300, show_as_html: params.key?('debug'), javascript_delay: 3000, margin: {top: 10, bottom: 20, left: 15, right: 15 }, outline: {outline: true, outline_depth: 10 }, footer: {html: {template:'shared/_pdf_footer'}}
        end
      end
    end

  end
end
