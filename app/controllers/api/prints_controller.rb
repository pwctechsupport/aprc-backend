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

    def report_risk_excel
      @risks = Risk.all
      respond_to do |format|
        format.json
        format.pdf do
          render pdf: 'report_risk_excel', layout: 'layouts/pdf.haml', template: 'api/prints/show.pdf.haml', dpi: 300, show_as_html: params.key?('debug'), javascript_delay: 3000, margin: {top: 10, bottom: 20, left: 15, right: 15 }, outline: {outline: true, outline_depth: 10 }, footer: {html: {template:'shared/_pdf_footer'}}
        end
        format.html
        format.xlsx {
          response.headers[
            'Content-Disposition'
          ] = "attachment; filename=report_risk.xlsx"
        }
      end
    end

    def report_risk
      @risks = Risk.all
      respond_to do |format|
        format.json
        format.pdf do
          render pdf: 'report_risk', layout: 'layouts/pdf.haml', template: 'api/prints/report_risk.pdf.haml', dpi: 300, show_as_html: params.key?('debug'), javascript_delay: 3000, margin: {top: 10, bottom: 20, left: 15, right: 15 }, outline: {outline: true, outline_depth: 10 }, footer: {html: {template:'shared/_pdf_footer'}}
        end
        format.xlsx {
          response.headers[
            'Content-Disposition'
          ] = "attachment; filename=report_risk.xlsx"
        }
      end
    end

    def business_process_excel
      @business_processes = BusinessProcess.where(id: params[:business_process_ids])
      respond_to do |format|
        format.json
        format.pdf do
          render pdf: 'business_process_excel', layout: 'layouts/pdf.haml', template: 'api/prints/show.pdf.haml', dpi: 300, show_as_html: params.key?('debug'), javascript_delay: 3000, margin: {top: 10, bottom: 20, left: 15, right: 15 }, outline: {outline: true, outline_depth: 10 }, footer: {html: {template:'shared/_pdf_footer'}}
        end
        format.html
        format.xlsx {
          response.headers[
            'Content-Disposition'
          ] = "attachment; filename=business_process.xlsx"
        }
      end
    end

    def risk_excel
      @risks = Risk.where(id: params[:risk_ids])
      respond_to do |format|
        format.json
        format.pdf do
          render pdf: 'risk_excel', layout: 'layouts/pdf.haml', template: 'api/prints/show.pdf.haml', dpi: 300, show_as_html: params.key?('debug'), javascript_delay: 3000, margin: {top: 10, bottom: 20, left: 15, right: 15 }, outline: {outline: true, outline_depth: 10 }, footer: {html: {template:'shared/_pdf_footer'}}
        end
        format.html
        format.xlsx {
          response.headers[
            'Content-Disposition'
          ] = "attachment; filename=risk.xlsx"
        }
      end
    end

    def control_excel
      @controls = Control.where(id: params[:risk_ids])
      respond_to do |format|
        format.json
        format.pdf do
          render pdf: 'control_excel', layout: 'layouts/pdf.haml', template: 'api/prints/show.pdf.haml', dpi: 300, show_as_html: params.key?('debug'), javascript_delay: 3000, margin: {top: 10, bottom: 20, left: 15, right: 15 }, outline: {outline: true, outline_depth: 10 }, footer: {html: {template:'shared/_pdf_footer'}}
        end
        format.html
        format.xlsx {
          response.headers[
            'Content-Disposition'
          ] = "attachment; filename=Control.xlsx"
        }
      end
    end
    
    def policy_category_excel
      @policy_categories = PolicyCategory.where(id: params[:policy_category_ids])
      respond_to do |format|
        format.json
        format.pdf do
          render pdf: 'policy_category_excel', layout: 'layouts/pdf.haml', template: 'api/prints/show.pdf.haml', dpi: 300, show_as_html: params.key?('debug'), javascript_delay: 3000, margin: {top: 10, bottom: 20, left: 15, right: 15 }, outline: {outline: true, outline_depth: 10 }, footer: {html: {template:'shared/_pdf_footer'}}
        end
        format.html
        format.xlsx {
          response.headers[
            'Content-Disposition'
          ] = "attachment; filename=PolicyCategory.xlsx"
        }
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

    def business_process
      @business_process = BusinessProcess.find(params[:id])
      respond_to do |format|
        format.json
        format.pdf do
          render pdf: 'business_process', layout: 'layouts/pdf.haml', template: 'api/prints/business_process.pdf.haml', dpi: 300, show_as_html: params.key?('debug'), javascript_delay: 3000, margin: {top: 10, bottom: 20, left: 15, right: 15 }, outline: {outline: true, outline_depth: 10 }, footer: {html: {template:'shared/_pdf_footer'}}
        end
      end
    end

    # def report
    #   @policy = Policy.find(params[:id])
    #   respond_to do |format|
    #     format.json
    #     format.pdf do
    #       render pdf: 'report', layout: 'layouts/pdf.haml', template: 'api/prints/report.pdf.haml', dpi: 300, show_as_html: params.key?('debug'), javascript_delay: 3000, margin: {top: 10, bottom: 20, left: 15, right: 15 }, outline: {outline: true, outline_depth: 10 }, footer: {html: {template:'shared/_pdf_footer'}}
    #     end
    #     format.xlsx
    #   end
    # end

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
