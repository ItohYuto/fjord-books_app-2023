# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test '#editable? if you are the person who posted the report, return true' do
    contributor = User.new
    report = contributor.reports.new
    assert report.editable?(contributor)
  end

  test '#editable? If you are not the person who posted the daily report, return false' do
    contributor = User.new
    viewer = User.new
    report = contributor.reports.new
    assert_not report.editable?(viewer)
  end
end
