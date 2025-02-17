table 37079307 "ESL Snapshot Role"
{
    Caption = 'Snapshot Role';
    DataPerCompany = false;
    DrillDownPageID = 37079307;
    LookupPageID = 37079307;

    fields
    {
        field(1; "Role ID"; Code[20])
        {
            Caption = 'Role ID';
        }
        field(2; "Role Name"; Text[30])
        {
            Caption = 'Role Name';
        }
        field(1001; "Snapshot No."; Code[20])
        {
            Caption = 'Snapshot No.';
            NotBlank = true;
            TableRelation = Table37079302.Field1;
        }
        field(1002; "Exists in Live"; Boolean)
        {
            CalcFormula = Exist("Permission Set" WHERE(Role ID=FIELD(Role ID)));
            Caption = 'Exists in Live';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1003;"Snapshot Permissions";Integer)
        {
            BlankZero = true;
            CalcFormula = Count("ESL Snapshot Permission" WHERE (Snapshot No.=FIELD(Snapshot No.),
                                                                 Role ID=FIELD(Role ID)));
            Caption = 'Snapshot Permissions';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1004;"Live Permissions";Integer)
        {
            BlankZero = true;
            CalcFormula = Count(Permission WHERE (Role ID=FIELD(Role ID)));
            Caption = 'Live Permissions';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1005;"Created Date Time";DateTime)
        {
            CalcFormula = Lookup(Table37079302.Field4 WHERE (Field1=FIELD(Snapshot No.)));
            Caption = 'Created Date Time';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Snapshot No.","Role ID")
        {
            Clustered = true;
        }
        key(Key2;"Role ID")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Text001: Label 'Overwrite existing %1?';

    [Scope('Internal')]
    procedure RestoreRole(NoConfirm: Boolean)
    var
        UserRole: Record "2000000004";
        Permission: Record "2000000005";
        ESLSnapshotPermission: Record "37079308";
    begin
        IF NOT NoConfirm THEN
          IF NOT CONFIRM(Text001,FALSE,UserRole.TABLECAPTION) THEN
            EXIT;

        IF UserRole.GET("Role ID") THEN BEGIN
          UserRole.VALIDATE(Name,"Role Name");
          UserRole.MODIFY(TRUE);
        END ELSE BEGIN
          UserRole.VALIDATE("Role ID","Role ID");
          UserRole.VALIDATE(Name,"Role Name");
          UserRole.INSERT(TRUE);
        END;

        Permission.RESET;
        Permission.SETRANGE("Role ID","Role ID");
        Permission.DELETEALL(TRUE);

        ESLSnapshotPermission.RESET;
        ESLSnapshotPermission.SETRANGE("Snapshot No.","Snapshot No.");
        ESLSnapshotPermission.SETRANGE("Role ID","Role ID");
        IF ESLSnapshotPermission.FIND('-') THEN
          REPEAT
            Permission.VALIDATE("Role ID","Role ID");
            Permission.VALIDATE("Object Type",ESLSnapshotPermission."Object Type");
            Permission.VALIDATE("Object ID",ESLSnapshotPermission."Object ID");
            Permission.VALIDATE("Read Permission",ESLSnapshotPermission."Read Permission");
            Permission.VALIDATE("Insert Permission",ESLSnapshotPermission."Insert Permission");
            Permission.VALIDATE("Modify Permission",ESLSnapshotPermission."Modify Permission");
            Permission.VALIDATE("Delete Permission",ESLSnapshotPermission."Delete Permission");
            Permission.VALIDATE("Execute Permission",ESLSnapshotPermission."Execute Permission");
            IF FORMAT(ESLSnapshotPermission."Security Filter") <> '' THEN
              Permission.VALIDATE("Security Filter",ESLSnapshotPermission."Security Filter");
            Permission.INSERT(TRUE);
          UNTIL ESLSnapshotPermission.NEXT = 0;
    end;
}

