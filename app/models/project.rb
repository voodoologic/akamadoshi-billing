class Project < ActiveRecord::Base
  include ::OSB
  include DateFormats
  include Trackstamps
  include ProjectSearch

  scope :multiple, ->(ids_list) {where("id in (?)", ids_list.is_a?(String) ? ids_list.split(',') : [*ids_list]) }
  scope :client_id, ->(client_id) { where(client_id: client_id) }
  scope :manager_id, ->(manager_id) { where(manager_id: manager_id) }
  scope :created_at, ->(created_at) { where(created_at: created_at)}

  belongs_to :client
  belongs_to :manager, class_name: 'Staff', foreign_key: 'manager_id'
  belongs_to :company
  belongs_to :user
  has_many :project_tasks, dependent: :destroy
  has_many :logs, dependent: :destroy
  has_many :team_members, dependent: :destroy
  has_many :staffs, through:  :team_members
  has_many :logs, dependent: :destroy
  has_many :invoices, dependent: :destroy

  accepts_nested_attributes_for :project_tasks , :reject_if => proc { |task| task['task_id'].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :team_members ,  :reject_if => proc { |staff| staff['staff_id'].blank? }, :allow_destroy => true

  acts_as_archival
  acts_as_paranoid

  before_save :check_estimate_hours

  def check_estimate_hours
    self.total_hours = self.total_hours.present? ? self.total_hours : 0.0
  end

  def self.filter(params, per_page)
    mappings = {active: 'unarchived', archived: 'archived', deleted: 'only_deleted'}
    user = User.current
    date_format = user.nil? ? '%Y-%m-%d' : (user.settings.date_format || '%Y-%m-%d')

    projects = self
    projects = projects.client_id(params[:client_id]) if params[:client_id].present?
    projects = projects.manager_id(params[:manager_id]) if params[:manager_id].present?
    projects = projects.created_at(
        (Date.strptime(params[:create_at_start_date], date_format).in_time_zone .. Date.strptime(params[:create_at_end_date], date_format).in_time_zone)
    ) if params[:create_at_start_date].present?
    projects = projects.send(mappings[params[:status].to_sym]) if params[:status].present?
    
    projects.page(params[:page]).per(per_page)
  end

  def self.multiple_projects ids
    ids = ids.split(',') if ids and ids.class == String
    where('id IN(?)', ids)
  end


  def self.recover_archived ids
    self.multiple_projects(ids).each { |project| project.unarchive }
  end

  def self.recover_deleted ids
    multiple_projects(ids).only_deleted.each do |project|
      project.restore
      project.unarchive
    end
  end

  def unscoped_client
    self.client
  end

  def group_date
    created_at.strftime('%B %Y')
  end

  def image_name
    "#{unscoped_client.first_name.first.camelize}#{unscoped_client.last_name.first.camelize }" rescue ''
  end

  def log_hours
    project_tasks.map(&:spent_time).sum rescue 0
  end

  def add_to_team(staff)
    team_members.create(name: staff.name, email: staff.email, rate: staff.rate, staff_id: staff.id)
  end

end
