#
# Open Source Billing - A super simple software to create & send invoices to your customers and
# collect payments.
# Copyright (C) 2013 Mark Mian <mark.mian@opensourcebilling.org>
#
# This file is part of Open Source Billing.
#
# Open Source Billing is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Open Source Billing is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Open Source Billing.  If not, see <http://www.gnu.org/licenses/>.
#
class Tax < ActiveRecord::Base

  include TaxSearch
  # scope
  scope :multiple, lambda { |ids_list| where("id in (?)", ids_list.is_a?(String) ? ids_list.split(',') : [*ids_list]) }
  scope :archive_multiple, lambda {|ids| multiple(ids).map(&:archive)}
  scope :delete_multiple, lambda {|ids| multiple(ids).map(&:destroy)}
  scope :created_at, -> (created_at) { where(created_at: created_at) }
  scope :percentage, -> (percentage) { where(percentage: percentage) }

  # associations
  has_many :invoice_line_items
  has_many :items
  has_many :expenses
  has_many :invoices
  validates :name, :presence => true
  validates :percentage, :presence => true

  # archive and delete
  acts_as_archival
  acts_as_paranoid

  paginates_per 10

  def self.recover_archived(ids)
    multiple(ids).each {|tax| tax.archive_number = nil; tax.archived_at = nil; tax.save}
  end

  def self.recover_deleted(ids)
    multiple(ids).only_deleted.each { |tax| tax.archive_number = nil; tax.archived_at = nil; tax.deleted_at = nil; tax.save }
  end

  def self.filter(params, per_page)
    mappings = {active: 'unarchived', archived: 'archived', deleted: 'only_deleted'}
    user = User.current
    date_format = user.nil? ? '%Y-%m-%d' : (user.settings.date_format || '%Y-%m-%d')

    taxes = params[:search].present? ? Tax.search(params[:search]).records : Tax.all
    taxes = taxes.created_at(
        (Date.strptime(params[:create_at_start_date], date_format).in_time_zone .. Date.strptime(params[:create_at_end_date], date_format).in_time_zone)
    ) if params[:create_at_start_date].present?
    taxes = taxes.percentage((params[:min_percentage].to_i .. params[:max_percentage].to_i)) if params[:min_percentage].present?
    taxes = taxes.send(mappings[params[:status].to_sym]) if params[:status].present?

    taxes.page(params[:page]).per(per_page)
  end

  def self.is_exits? tax_name
    where(name: tax_name).present?
  end
  def group_date
    created_at.strftime('%B %Y')
  end

end