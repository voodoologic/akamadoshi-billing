class AddHoursSpentTimeDatesToProjectTasks < ActiveRecord::Migration
  def change
    add_column :project_tasks, :start_date, :datetime
    add_column :project_tasks, :due_date, :datetime
    add_column :project_tasks, :hours, :float
    add_column :project_tasks, :spent_time, :float
  end
end
