table 33020406 "HR Cue"
{

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "Vacancy List"; Integer)
        {
            CalcFormula = Count("Vacancy Header New");
            FieldClass = FlowField;
        }
        field(3; "Application List"; Integer)
        {
            CalcFormula = Count("Application New");
            FieldClass = FlowField;
        }
        field(4; "Budget List"; Integer)
        {
            CalcFormula = Count("Manpower Budget_Header");
            FieldClass = FlowField;
        }
        field(5; "Intern List"; Integer)
        {
            CalcFormula = Count("Intern Records" WHERE(Posted = CONST(No)));
            FieldClass = FlowField;
        }
        field(6; "Trainee List"; Integer)
        {
            CalcFormula = Count("Trainee Records" WHERE(Posted = CONST(No)));
            FieldClass = FlowField;
        }
        field(7; "Outsource Staff List"; Integer)
        {
            CalcFormula = Count("OutSource Staffs" WHERE(Posted = CONST(No)));
            FieldClass = FlowField;
        }
        field(8; "Disciplinary Issue List"; Integer)
        {
            CalcFormula = Count("Disciplinary Issue Record" WHERE(Posted = CONST(No)));
            FieldClass = FlowField;
        }
        field(9; "Posted Intern Lists"; Integer)
        {
            CalcFormula = Count("Intern Records" WHERE(Posted = CONST(Yes)));
            FieldClass = FlowField;
        }
        field(10; "Posted Trainee Lists"; Integer)
        {
            CalcFormula = Count("Trainee Records" WHERE(Posted = CONST(Yes)));
            FieldClass = FlowField;
        }
        field(11; "Posted Outsource Staff Lists"; Integer)
        {
            CalcFormula = Count("OutSource Staffs" WHERE(Posted = CONST(Yes)));
            FieldClass = FlowField;
        }
        field(12; "Posted Disciplinary Issue List"; Integer)
        {
            CalcFormula = Count("Disciplinary Issue Record" WHERE(Posted = CONST(Yes)));
            FieldClass = FlowField;
        }
        field(13; "Employee Requisition List"; Integer)
        {
            CalcFormula = Count("Emp Requisition Form" WHERE(Posted = CONST(Yes)));
            FieldClass = FlowField;
        }
        field(14; "Approved Emp. Req. List"; Integer)
        {
            CalcFormula = Count("Emp Requisition Form" WHERE(Status = CONST(Approved)));
            FieldClass = FlowField;
        }
        field(15; "Not Approved Emp. Req. List"; Integer)
        {
            CalcFormula = Count("Emp Requisition Form" WHERE(Status = CONST(Not Approved)));
            FieldClass = FlowField;
        }
        field(16; "On Hold Emp. Req. List"; Integer)
        {
            CalcFormula = Count("Emp Requisition Form" WHERE(Status = CONST(On Hold)));
            FieldClass = FlowField;
        }
        field(17; "Resubmit Emp. Req. List"; Integer)
        {
            CalcFormula = Count("Emp Requisition Form" WHERE(Status = CONST(Resubmit)));
            FieldClass = FlowField;
        }
        field(18; "Job Title"; Integer)
        {
            CalcFormula = Count("Job Title");
            FieldClass = FlowField;
        }
        field(19; Item; Integer)
        {
            CalcFormula = Count(Item);
            FieldClass = FlowField;
        }
        field(20; "Employee - Confirmed"; Integer)
        {
            CalcFormula = Count(Employee WHERE(Status = CONST(Confirmed)));
            FieldClass = FlowField;
        }
        field(21; "Employee - Probation"; Integer)
        {
            CalcFormula = Count(Employee WHERE(Status = CONST(Probation)));
            FieldClass = FlowField;
        }
        field(30; "Leave - Pending for Approval"; Integer)
        {
            CalcFormula = Count("Post Leave Request" WHERE(Approved = CONST(No),
                                                            Rejected = CONST(No)));
            FieldClass = FlowField;
        }
        field(31; "Leave - Approved List"; Integer)
        {
            CalcFormula = Count("Leave ApprovedOrDisapproved" WHERE(Approved = CONST(Yes)));
            FieldClass = FlowField;
        }
        field(32; "Leave - Disapprove List"; Integer)
        {
            CalcFormula = Count("Leave ApprovedOrDisapproved" WHERE(Disapproved = CONST(Yes)));
            FieldClass = FlowField;
        }
        field(33; "ODD - Approved List"; Integer)
        {
            CalcFormula = Count("ODD/ Training/ Gatepass List" WHERE(Type = CONST(ODD),
                                                                      Approve = CONST(Yes)));
            FieldClass = FlowField;
        }
        field(34; "ODD - Disapproved List"; Integer)
        {
            CalcFormula = Count("ODD/ Training/ Gatepass List" WHERE(Type = CONST(ODD),
                                                                      Disapprove = CONST(Yes)));
            FieldClass = FlowField;
        }
        field(35; "Training - Approved List"; Integer)
        {
            CalcFormula = Count("ODD/ Training/ Gatepass List" WHERE(Type = CONST(Training),
                                                                      Approve = CONST(Yes)));
            FieldClass = FlowField;
        }
        field(36; "Training - Disapproved List"; Integer)
        {
            CalcFormula = Count("ODD/ Training/ Gatepass List" WHERE(Type = CONST(Training),
                                                                      Disapprove = CONST(Yes)));
            FieldClass = FlowField;
        }
        field(37; "Gate Pass - Approved List"; Integer)
        {
            CalcFormula = Count("ODD/ Training/ Gatepass List" WHERE(Type = CONST(Gatepass),
                                                                      Approve = CONST(Yes)));
            FieldClass = FlowField;
        }
        field(38; "Gate Pass - Disapproved List"; Integer)
        {
            CalcFormula = Count("ODD/ Training/ Gatepass List" WHERE(Type = CONST(Gatepass),
                                                                      Disapprove = CONST(Yes)));
            FieldClass = FlowField;
        }
        field(50; "Employee Activity - Not Posted"; Integer)
        {
            CalcFormula = Count("Employee Activity" WHERE(Posted = CONST(No)));
            FieldClass = FlowField;
        }
        field(51; "Internal Vacancy - Open"; Integer)
        {
            CalcFormula = Count("Internal Vacancy" WHERE(Closed = CONST(No)));
            FieldClass = FlowField;
        }
        field(52; "Internal Vacancy - Close"; Integer)
        {
            CalcFormula = Count("Internal Vacancy" WHERE(Closed = CONST(Yes)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

