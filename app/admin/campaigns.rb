ActiveAdmin.register Campaign do
  
  platform_label = "Platform(s)"

  index do
    column :name
    column :budget
    column platform_label, class: :platform do |campaign|
      campaigns.platforms.map(&:name).join(", ")
    end
    actions
  end


  show do |campaign|
    attributes_table do
      row :name
      row :budget
      row :platforms do
        campaign.platforms.pluck(:name).join(', ')
      end
    end
  end


  form do |f|
    f.inputs do
      f.input :name, required: true
      f.input :budget, required: true
      f.input :platforms, as: :check_boxes, collection: Platform.all,
              label: platform_label, required: true
    end
    f.actions
  end

  controller do
    before_filter :log_platform_changes, only: :update

    private

    def log_platform_changes
      return if campaign.nil? || campaign.budget < 1000
      log_platform_changes_for(campaign)
    end

    def log_platform_changes_for(campaign)
      { "removed" => removals, "added" => additions }.each do |action, pids|
        pids.each do |pid|
          platform = Platform.find(pid)
          ActiveAdmin::Comment.create!(
            namespace: "admin",
            resource: campaign,
            body: "#{current_admin_user.email} has #{action} the platform #{platform.name}.")
        end
      end
    end

    def removals
      old_pids - new_pids
    end

    def additions
      new_pids - old_pids
    end

    def campaign
      @campaign ||= Campaign.find(params[:id])
    end

    def old_pids
      campaign.platforms.pluck(:id)
    end

    def new_pids
      params[:campaign][:platform_ids].reject(&:empty?).map(&:to_i)
    end
  end

end
