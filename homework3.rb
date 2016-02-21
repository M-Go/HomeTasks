class Developer

  MAX_TASKS = 10

  def initialize(name)
    @name = name
    @all_tasks = []
  end

  def add_task(new_task)
    if can_add_task?
      @all_tasks << new_task
      puts '%s: добавлена задача "%s". Всего в списке задач: %i' % [@name, new_task, @all_tasks.size]
    else
      raise ArgumentError, 'Слишком много работы!'
    end
  end

  def tasks
    @all_tasks.map.each_with_index.each { |task, index| '%i. %s' % [index + 1, task] }
  end

  def work!
    if can_work?
      task_completed
    else
      raise ArgumentError, 'Нечего делать!'
    end
  end

  def status
    case @all_tasks.size
    when 0
      puts 'Свободен'
    when (1..9)
      puts 'Работаю'
    when 10
      puts 'Занят'
    end
  end

  def can_add_task?
    @all_tasks.size < MAX_TASKS
  end

  def can_work?
    !@all_tasks.empty?
  end

  def task_completed
    puts '%s: выполнена задача "%s". Осталось задач: %i' % [@name, @all_tasks[0], @all_tasks.size - 1]
    @all_tasks.shift
  end

end


class JuniorDeveloper < Developer

  MAX_TASKS = 5

  def add_task(new_task)
    if new_task.size > 20
      raise ArgumentError, 'Слишком сложно!'
    else
      super
    end
  end

  def can_add_task?
    @all_tasks.size < MAX_TASKS
  end

  def task_completed
    puts '%s: пытаюсь делать задачу "%s". Осталось задач: %i' % [@name, @all_tasks[0], @all_tasks.size - 1]
    @all_tasks.shift
  end

end


class SeniorDeveloper < Developer

  MAX_TASKS = 15

  def work!
    if can_work?
      chance = rand(0..1)
      if chance == 0
        2.times { task_completed }
      else
        puts 'Что-то лень...'
      end
    else
      raise ArgumentError, 'Нечего делать!'
    end
  end

  def can_add_task?
    @all_tasks.size < MAX_TASKS
  end

  def task_completed
    if can_work?
      puts '%s: выполнена задача "%s". Осталось задач: %i' % [@name, @all_tasks[0], @all_tasks.size - 1]
      @all_tasks.shift
    else
      raise ArgumentError, 'Нечего делать!'
    end
  end

end