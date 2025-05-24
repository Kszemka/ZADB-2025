class Employee::EmployeeAddInteractor < ResponseService
    string :first_name
    string :last_name
    string :email
    integer :manager_id
    integer :position_id

    attr_reader :manager, :position

    set_callback :validate, :before, -> do
        set_position
        set_manager
    end

    validates :first_name, :last_name, :email, presence: true
    validates_with EmployeeAddValidator

    def execute
        EmployeeService.add_employee_to_open_position(self)
    end

    private

    def set_position
        @position = Position.find_by(id: position_id)
    end

    def set_manager
        @manager  = Employee.find_by(id: manager_id)
    end

end
