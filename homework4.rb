class Developer

  MAX_TASKS = 10

  def initialize(name)
    @name = { :developer => name }
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
    @all_tasks.map.each_with_index { |task, index| '%i. %s' % [index + 1, task] }
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
        'Свободен'
      when (1..9)
        'Работаю'
      when 10
        'Занят'
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

  def initialize(name)
    @name = { :junior => name }
    @all_tasks = []
  end

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

  def initialize(name)
    @name = { :senior => name }
    @all_tasks = []
  end

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


class Team

attr_accessor :seniors, :developers, :juniors

  def initialize(&block)
    @team = {}
    instance_eval(&block)
  end

  def have_seniors(*names)
    @team[:seniors] = names.map.each { |name| SeniorDeveloper.new(name) }
  end

  def have_developers(*names)
    @team[:developers] = names.map.each { |name| Developer.new(name) }
  end

  def have_juniors(*names)
    @team[:juniors] = names.map.each { |name| JuniorDeveloper.new(name)}
  end

  def juniors
    @team[:juniors]
  end

  def developers
    @team[:developers]
  end

  def seniors
    @team[:seniors]
  end

  def priority(*sequence)
    @priority_array = []
    case sequence
    when :juniors
      @team[:juniors].map.each { |dev| dev.can_add_task? }
      @team[:juniors].sort_by { |all_tasks| [all_tasks.size.reverse] }
      @priority_array << @team[:juniors]
    when :developers
      @team[:developers].map.each { |dev| dev.can_add_task? }
      @team[:developers].sort_by { |all_tasks| [all_tasks.size.reverse] }
      @priority_array << @team[:developers]
    when :seniors
      @team[:seniors].map.each { |dev| dev.can_add_task? }
      @team[:seniors].sort_by { |all_tasks| [all_tasks.size.reverse] }
      @priority_array << @team[:seniors]
    end
  end

  def add_task(new_task)
    @team.priority
    @team_tasks = {}
    case @priority_array[0]
    when JuniorDeveloper
      if new_task.size > 20
        raise ArgumentError, 'Слишком сложно!'
      else
        @team_tasks[:juniors] << new_task
        @team.on_task(:junior).call
        @priority_array.shift
      end
    when Developer
      @team_tasks[:developers] << new_task
      puts '%s: добавлена задача "%s". Всего в списке задач: %i' % [@name[:developer], new_task, @all_tasks.size]
      @priority_array.shift
    when SeniorDeveloper
      @team_tasks[:seniors] << new_task
      @team.on_task(:senior).call
      @priority_array.shift
    end
  end

 def on_task(dev, &block)
    on_task(dev).call &block
  end

  def all
    @team.juniors.developers.seniors
  end

  def report
    @team.each { |dev| puts "#{dev.name}: #{@all_tasks}" }
  end

end


team = Team.new do
  have_seniors 'Олег', 'Оксана'
  have_developers 'Олеся', 'Василий', 'Игорь-Богдан'
  have_juniors 'Владислава', 'Аркадий', 'Рамеш'
  priority :juniors, :developers, :seniors
  on_task :junior do |dev, task|
    puts "Отдали задачу #{task} разработчику #{dev.name}, следите за ним!"
  end

  on_task :senior do |dev, task|
    puts "#{dev.name} сделает #{task}, но просит больше с такими глупостями не приставать"
  end
end