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
module RecurringProfilesHelper
  def new_recurring_message(is_currently_sent)
    message = is_currently_sent ? "Recurring profile has been created and sent to #{@recurring_profile.client.organization_name}" : "Recurring profile has been created successfully"
    notice = <<-HTML
       <p>#{message}.</p>
       <ul>
         <li><a href="/recurring_profiles/new">Create another recurring profile</a></li>
       </ul>
    HTML
    notice.html_safe
  end

  def recurring_profiles_archived ids
    notice = <<-HTML
     <p>#{ids.size} recurring profile(s) have been archived. You can find them under
     <a href="?status=archived&per=#{@per_page}" data-remote="true">Archived</a> section on this page.</p>
     <p><a href='recurring_profiles/undo_actions?ids=#{ids.join(",")}&archived=true&page=#{params[:page]}&per=#{session["#{controller_name}-per_page"]}'  data-remote="true">Undo this action</a> to move archived recurring profiles back to active.</p>
    HTML
    notice = notice.html_safe
  end

  def recurring_profiles_deleted ids
    notice = <<-HTML
     <p>#{ids.size} recurring profile(s) have been deleted. You can find them under
     <a href="?status=deleted&per=#{@per_page}" data-remote="true">Deleted</a> section on this page.</p>
     <p><a href='recurring_profiles/undo_actions?ids=#{ids.join(",")}&deleted=true&page=#{params[:page]}&per=#{session["#{controller_name}-per_page"]}'  data-remote="true">Undo this action</a> to move deleted recurring profiles back to active.</p>
    HTML
    notice = notice.html_safe
  end
end
