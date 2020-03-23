class GoogleSheetLoggingJob < ApplicationJob
  def perform(repair_attributes, callback)
    GoogleSheetLogger.new.call(repair_attributes, callback)
  end
end
