table 33020322 "Emp Activity Effective Date"
{

    fields
    {
        field(1; "Employee Code"; Code[20])
        {
        }
        field(2; Status; Option)
        {
            Description = ',Permanent Transfer,Temporary Transfer,Redesignation,Reporting Authority Change,Confirmed,Job Responsibility Change,Upgradation,Promotion,Probation,Probation Extension,Suspension,Left,Retired,Terminated,Trainee,Trial,Trf Sister Concern,Contract';
            OptionCaption = ',Permanent Transfer,Temporary Transfer,Redesignation,Reporting Authority Change,Confirmed,Job Responsibility Change,Upgradation,Promotion,Probation,Probation Extension,Suspension,Left,Retired,Terminated,Trainee,Trial,Trf Sister Concern,Contract';
            OptionMembers = ,"Permanent Transfer","Temporary Transfer",Redesignation,"Reporting Authority Change",Confirmed,"Job Responsibility Change",Upgradation,Promotion,Probation,"Probation Extension",Suspension,Left,Retired,Terminated,Trainee,Trial,"Trf Sister Concern",Contract;
        }
        field(3; "Effective Date"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Employee Code", Status)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

