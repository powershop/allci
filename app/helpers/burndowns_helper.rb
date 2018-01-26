module BurndownsHelper
  def calculate_burndown_section_for(build_task_run)
    status = (build_task_run.state == 'success' ? 'success' : 'failure')

    label = if build_task_run.stage == "bootstrap"
      "Bootstrap (#{build_task_run.duration.to_i})"
    else
      "less slow this way!"#build_task_run.short_label
    end

    scale_time = @timeframe.max - @timeframe.min
    scaling_factor = 100.0 / scale_time

    left  = build_task_run.relative_start(@timeframe.min) * scaling_factor

    width = if build_task_run.duration && fits(build_task_run, scaling_factor)
      build_task_run.duration * scaling_factor
    else
      100 - ( build_task_run.relative_start(@timeframe.min) * scaling_factor )
    end

    yield(label, status, left, width)
  end

  def fits(build_task_run, scaling_factor)
    build_task_run.relative_start(@timeframe.min) * scaling_factor + (build_task_run.duration*scaling_factor) <= 100
  end
end
