module Api
  class PrintsController < ApiController

    def policy
      @policy = Policy.find(params[:id])
      respond_to do |format|
        format.json
        format.pdf do
          render pdf: 'policy', layout: 'layouts/pdf.haml', template: 'api/prints/policy.pdf.haml', dpi: 300, show_as_html: params.key?('debug'), javascript_delay: 3000, margin: {top: 20, bottom: 20, left: 15, right: 15 }, outline: {outline: true, outline_depth: 10 }, footer: {html: {template:'shared/_pdf_report_footer'}}, header: {html: {template:'shared/_pdf_header'}}
        end
      end
    end

    def report_risk_excel
      @risks = Risk.all
      respond_to do |format|
        format.json
        format.pdf do
          render pdf: 'report_risk_excel', layout: 'layouts/pdf.haml', template: 'api/prints/show.pdf.haml', dpi: 300, show_as_html: params.key?('debug'), javascript_delay: 3000, margin: {top: 20, bottom: 20, left: 15, right: 15 }, outline: {outline: true, outline_depth: 10 }, footer: {html: {template:'shared/_pdf_report_footer'}}, header: {html: {template:'shared/_pdf_header'}}
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
      pub_risk = Risk.where.not(id:PolicyRisk.pluck(:risk_id)).where.not(published_at: nil).pluck(:id)
      rel_risk = Risk.where.not(id:PolicyRisk.pluck(:risk_id)).where(status: "release").pluck(:id)
      all_risk = (pub_risk + rel_risk).uniq
      @risks = Risk.where(id: all_risk).includes(:business_processes).order("business_processes.name ASC").uniq
      respond_to do |format|
        format.json
        format.pdf do
          render pdf: 'report_risk', layout: 'layouts/pdf.haml', template: 'api/prints/report_risk.pdf.haml',orientation: "Landscape", dpi: 300, show_as_html: params.key?('debug'), javascript_delay: 3000, margin: {top: 60, bottom: 20, left: 15, right: 15 }, outline: {outline: true, outline_depth: 10 }, footer: {html: {template:'shared/_pdf_report_footer'}}, header: {html: {template:'shared/_pdf_header_report_risk'}}
        end
        format.xlsx {
          response.headers[
            'Content-Disposition'
          ] = "attachment; filename=report_risk.xlsx"
        }
      end
    end

    def report_risk_policy
      pub_risk = Risk.where.not(id:ControlRisk.pluck(:risk_id)).where.not(published_at: nil).pluck(:id)
      rel_risk = Risk.where.not(id:ControlRisk.pluck(:risk_id)).where(status: "release").pluck(:id)
      all_risk = (pub_risk + rel_risk).uniq
      @risks = Risk.where(id: all_risk).includes(:business_processes).order("business_processes.name ASC").uniq
      respond_to do |format|
        format.json
        format.pdf do
          render pdf: 'report_risk_policy', layout: 'layouts/pdf.haml', template: 'api/prints/report_risk_policy.pdf.haml',orientation: "Landscape", dpi: 300, show_as_html: params.key?('debug'), javascript_delay: 3000, margin: {top: 60, bottom: 20, left: 15, right: 15 }, outline: {outline: true, outline_depth: 10 }, footer: {html: {template:'shared/_pdf_report_footer'}}, header: {html: {template:'shared/_pdf_header_report_risk_policy'}}
        end
        format.xlsx {
          response.headers[
            'Content-Disposition'
          ] = "attachment; filename=report_risk_policy.xlsx"
        }
      end
    end

    def report_resource_rating
      zone = ActiveSupport::TimeZone.new("Jakarta")
      pub_res = Resource.where.not(published_at: nil)
      rel_res = Resource.where(status: "release")
      all_res = (pub_res + rel_res).uniq
      res = all_res.select{|x| x.category != "Flowchart"}
      @resources = res.map{|x| [
        name: x&.name&.capitalize&.html_safe,
        category: x&.category,
        visit: x&.visit,
        average: Resource.rate(x).third.nan? ? "Not Rated" : Resource.rate(x).fourth,
        total: Resource.rate(x).first,
        created_by: x&.versions&.find_by(event:"create")&.whodunnit.present? ? User&.find(x&.versions&.find_by(event:"create")&.whodunnit).name : "",
        created_on: x&.versions&.find_by(event:"create")&.present? ? x&.versions&.find_by(event:"create")&.created_at.in_time_zone(zone).strftime("%d-%m-%Y %T %Z") : "",
        last_updated_on: x&.updated_at.present? ? x&.updated_at.in_time_zone(zone).strftime("%d-%m-%Y %T %Z") : "",
        last_updated_by: x&.versions&.last&.whodunnit.present? ? User&.find(x&.versions&.last&.whodunnit)&.name : ""   
        ]
      }.flatten(1).sort_by {|h| [h[:total],h[:average]]}.reverse
      respond_to do |format|
        format.json
        format.pdf do
          render pdf: 'report_resource_rating', layout: 'layouts/pdf.haml', template: 'api/prints/report_resource_rating.pdf.haml', orientation: "Landscape", dpi: 300, show_as_html: params.key?('debug'), javascript_delay: 3000, margin: {top: 60, bottom: 20, left: 15, right: 15 }, outline: {outline: true, outline_depth: 10 }, footer: {html: {template:'shared/_pdf_report_footer'}}, header: {html: {template:'shared/_pdf_header_report_resource_rating'}}
        end
        format.xlsx {
          response.headers[
            'Content-Disposition'
          ] = "attachment; filename=report_resource_rating.xlsx"
        }
      end
    end

    def unmapped_risk
      @tags = Tag.includes(:business_process).order("business_processes.name ASC").where.not(risk_id:nil).uniq
      respond_to do |format|
        format.json
        format.pdf do
          render pdf: 'unmapped_risk', layout: 'layouts/pdf.haml', template: 'api/prints/unmapped_risk.pdf.haml',orientation: "Landscape", dpi: 300, show_as_html: params.key?('debug'), javascript_delay: 3000, margin: {top: 65, bottom: 20, left: 15, right: 15 }, outline: {outline: true, outline_depth: 10 }, footer: {html: {template:'shared/_pdf_report_footer'}}, header: {html: {template:'shared/_pdf_header_unmapped_risk'}}
        end
        format.xlsx {
          response.headers[
            'Content-Disposition'
          ] = "attachment; filename=unmapped_risk.xlsx"
        }
      end
    end

    def unmapped_control
      @tags = Tag.includes(:business_process).order("business_processes.name ASC").where.not(control_id:nil).uniq
      respond_to do |format|
        format.json
        format.pdf do
          render pdf: 'unmapped_control', layout: 'layouts/pdf.haml', template: 'api/prints/unmapped_control.pdf.haml',orientation: "Landscape", dpi: 300, show_as_html: params.key?('debug'), javascript_delay: 3000, margin: {top: 65, bottom: 20, left: 15, right: 15 }, outline: {outline: true, outline_depth: 10 }, footer: {html: {template:'shared/_pdf_report_footer'}}, header: {html: {template:'shared/_pdf_header_unmapped_control'}}
        end
        format.xlsx {
          response.headers[
            'Content-Disposition'
          ] = "attachment; filename=unmapped_control.xlsx"
        }
      end
    end

    def report_control_policy
      @controls = Control.where(status: "release")
      
      respond_to do |format|
        format.json
        format.pdf do
          render pdf: 'report_control_policy', layout: 'layouts/pdf.haml', template: 'api/prints/report_control_policy.pdf.haml',orientation: "Landscape", dpi: 300, show_as_html: params.key?('debug'), javascript_delay: 3000, margin: {top: 60, bottom: 20, left: 15, right: 15 }, outline: {outline: true, outline_depth: 10 }, footer: {html: {template:'shared/_pdf_report_footer'}}, header: {html: {template:'shared/_pdf_header_report_control_policy'}}
        end
        format.xlsx {
          response.headers[
            'Content-Disposition'
          ] = "attachment; filename=report_control_policy.xlsx"
        }
      end
    end

    def business_process_excel
      @business_processes = BusinessProcess.where(id: params[:business_process_ids])
      respond_to do |format|
        format.json
        format.pdf do
          render pdf: 'business_process_excel', layout: 'layouts/pdf.haml', template: 'api/prints/show.pdf.haml', dpi: 300, show_as_html: params.key?('debug'), javascript_delay: 3000, margin: {top: 20, bottom: 20, left: 15, right: 15 }, outline: {outline: true, outline_depth: 10 }, footer: {html: {template:'shared/_pdf_report_footer'}}, header: {html: {template:'shared/_pdf_header'}}
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
          render pdf: 'risk_excel', layout: 'layouts/pdf.haml', template: 'api/prints/show.pdf.haml', dpi: 300, show_as_html: params.key?('debug'), javascript_delay: 3000, margin: {top: 20, bottom: 20, left: 15, right: 15 }, outline: {outline: true, outline_depth: 10 }, footer: {html: {template:'shared/_pdf_report_footer'}}, header: {html: {template:'shared/_pdf_header'}}
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
      @controls = Control.where(id: params[:control_ids])
      respond_to do |format|
        format.json
        format.pdf do
          render pdf: 'control_excel', layout: 'layouts/pdf.haml', template: 'api/prints/show.pdf.haml', dpi: 300, show_as_html: params.key?('debug'), javascript_delay: 3000, margin: {top: 20, bottom: 20, left: 15, right: 15 }, outline: {outline: true, outline_depth: 10 }, footer: {html: {template:'shared/_pdf_report_footer'}}, header: {html: {template:'shared/_pdf_header'}}
        end
        format.html
        format.xlsx {
          response.headers[
            'Content-Disposition'
          ] = "attachment; filename=Control.xlsx"
        }
      end
    end

    def resource_excel
      @resources = Resource.where(id: params[:resource_ids])
      respond_to do |format|
        format.json
        format.pdf do
          render pdf: 'resource_excel', layout: 'layouts/pdf.haml', template: 'api/prints/show.pdf.haml', dpi: 300, show_as_html: params.key?('debug'), javascript_delay: 3000, margin: {top: 20, bottom: 20, left: 15, right: 15 }, outline: {outline: true, outline_depth: 10 }, footer: {html: {template:'shared/_pdf_report_footer'}}, header: {html: {template:'shared/_pdf_header'}}
        end
        format.html
        format.xlsx {
          response.headers[
            'Content-Disposition'
          ] = "attachment; filename=resource.xlsx"
        }
      end
    end
    
    def policy_category_excel
      @policy_categories = PolicyCategory.where(id: params[:policy_category_ids])
      respond_to do |format|
        format.json
        format.pdf do
          render pdf: 'policy_category_excel', layout: 'layouts/pdf.haml', template: 'api/prints/show.pdf.haml', dpi: 300, show_as_html: params.key?('debug'), javascript_delay: 3000, margin: {top: 20, bottom: 20, left: 15, right: 15 }, outline: {outline: true, outline_depth: 10 }, footer: {html: {template:'shared/_pdf_report_footer'}}, header: {html: {template:'shared/_pdf_header'}}
        end
        format.html
        format.xlsx {
          response.headers[
            'Content-Disposition'
          ] = "attachment; filename=PolicyCategory.xlsx"
        }
      end
    end

    def reference_excel
      @references = Reference.where(id: params[:reference_ids])
      respond_to do |format|
        format.json
        format.pdf do  
          render pdf: 'reference_excel', layout: 'layouts/pdf.haml', template: 'api/prints/show.pdf.haml', dpi: 300, show_as_html: params.key?('debug'), javascript_delay: 3000, margin: {top: 20, bottom: 20, left: 15, right: 15 }, outline: {outline: true, outline_depth: 10 }, footer: {html: {template:'shared/_pdf_report_footer'}}, header: {html: {template:'shared/_pdf_header'}}
        end
        format.html
        format.xlsx {
          response.headers[
            'Content-Disposition'
          ] = "attachment; filename=Reference.xlsx"
        }
      end
    end

    def risk
      @risk = Risk.find(params[:id])
      respond_to do |format|
        format.json
        format.pdf do
          render pdf: 'risk', layout: 'layouts/pdf.haml', template: 'api/prints/risk.pdf.haml', dpi: 300, show_as_html: params.key?('debug'), javascript_delay: 3000, margin: {top: 20, bottom: 20, left: 15, right: 15 }, outline: {outline: true, outline_depth: 10 }, footer: {html: {template:'shared/_pdf_report_footer'}}, header: {html: {template:'shared/_pdf_header'}}
        end
      end
    end

    def business_process
      @business_process = BusinessProcess.find(params[:id])
      respond_to do |format|
        format.json
        format.pdf do
          render pdf: 'business_process', layout: 'layouts/pdf.haml', template: 'api/prints/business_process.pdf.haml',orientation: "Landscape", dpi: 300, show_as_html: params.key?('debug'), javascript_delay: 3000, margin: {top: 20, bottom: 20, left: 15, right: 15 }, outline: {outline: true, outline_depth: 10 }, footer: {html: {template:'shared/_pdf_report_footer'}}, header: {html: {template:'shared/_pdf_header'}}
        end
      end
    end
    
    def business_process_control
      @business_process = BusinessProcess.find(params[:id])
      respond_to do |format|
        format.json
        format.pdf do
          render pdf: 'business_process_control', layout: 'layouts/pdf.haml', template: 'api/prints/business_process_control.pdf.haml', dpi: 300, show_as_html: params.key?('debug'), javascript_delay: 3000, margin: {top: 20, bottom: 20, left: 15, right: 15 }, outline: {outline: true, outline_depth: 10 }, footer: {html: {template:'shared/_pdf_report_footer'}}, header: {html: {template:'shared/_pdf_header'}}
        end
      end
    
    end

    # def report
    #   @policy = Policy.find(params[:id])
    #   respond_to do |format|
    #     format.json
    #     format.pdf do
    #       render pdf: 'report', layout: 'layouts/pdf.haml', template: 'api/prints/report.pdf.haml', dpi: 300, show_as_html: params.key?('debug'), javascript_delay: 3000, margin: {top: 20, bottom: 20, left: 15, right: 15 }, outline: {outline: true, outline_depth: 10 }, footer: {html: {template:'shared/_pdf_report_footer'}}
    #     end
    #     format.xlsx
    #   end
    # end

    def control
      @control = Control.find(params[:id])
      respond_to do |format|
        format.json
        format.pdf do
          render pdf: 'control', layout: 'layouts/pdf.haml', template: 'api/prints/control.pdf.haml', dpi: 300, show_as_html: params.key?('debug'), javascript_delay: 3000, margin: {top: 20, bottom: 20, left: 15, right: 15 }, outline: {outline: true, outline_depth: 10 }, footer: {html: {template:'shared/_pdf_report_footer'}}, header: {html: {template:'shared/_pdf_header'}}
        end
      end
    end

  end
end
