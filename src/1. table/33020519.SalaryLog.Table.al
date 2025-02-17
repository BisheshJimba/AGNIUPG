table 33020519 "Salary Log"
{

    fields
    {
        field(10; "Employee No."; Code[20])
        {
            Editable = false;
            TableRelation = Employee;
        }
        field(11; "Employee Name"; Text[80])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE(No.=FIELD(Employee No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(20;"Effective Date";Date)
        {
        }
        field(21;Level;Code[20])
        {
            Editable = false;
            TableRelation = "Salary Level";
        }
        field(22;Grade;Code[10])
        {
            Editable = false;
            TableRelation = "Salary Grade";
        }
        field(30;"Basic with Grade";Decimal)
        {
        }
        field(40;"Increment Value";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Employee No.","Effective Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Employee.RESET;
        Employee.SETRANGE("User ID",USERID);
        IF NOT Employee.FINDFIRST THEN BEGIN
          HRPermission.RESET;
          HRPermission.SETRANGE("User ID",USERID);
          IF HRPermission.FINDFIRST THEN
              IF (HRPermission."HR Admin" = FALSE) THEN
                  ERROR(Text0001);
        END;
    end;

    trigger OnInsert()
    begin
        Employee.RESET;
        Employee.SETRANGE("User ID",USERID);
        IF NOT Employee.FINDFIRST THEN BEGIN
          HRPermission.RESET;
          HRPermission.SETRANGE("User ID",USERID);
          IF HRPermission.FINDFIRST THEN
              IF (HRPermission."HR Admin" = FALSE) THEN
                  ERROR(Text0001);
        END;
    end;

    trigger OnModify()
    begin
        Employee.RESET;
        Employee.SETRANGE("User ID",USERID);
        IF NOT Employee.FINDFIRST THEN BEGIN
          HRPermission.RESET;
          HRPermission.SETRANGE("User ID",USERID);
          IF HRPermission.FINDFIRST THEN
              IF (HRPermission."HR Admin" = FALSE) THEN
                  ERROR(Text0001);
        END;
    end;

    var
        HRPermission: Record "33020304";
        Employee: Record "5200";
        Text0001: Label 'You do not have permission to view salary log.';
}

