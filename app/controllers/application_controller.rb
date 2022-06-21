class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session, only: Proc.new { |c| c.request.format.json? }
  before_action :set_paper_trail_whodunnit
  before_action :set_draftsman_whodunnit

end
