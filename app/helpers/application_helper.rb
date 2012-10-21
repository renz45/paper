module ApplicationHelper
  def body_class
    "#{controller.controller_name} #{controller_path.gsub('/', '-')}-#{controller.action_name} #{@body_class}"
  end
end
