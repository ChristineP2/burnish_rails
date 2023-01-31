# frozen_string_literal: true

namespace :brakeman do
  desc 'Check your code with Brakeman'
  task check: :environment do
    require 'brakeman'
    r = Brakeman.run app_path: '.', print_report: true, pager: false
    exit Brakeman::Warnings_Found_Exit_Code unless r.filtered_warnings.empty?
  end
end
