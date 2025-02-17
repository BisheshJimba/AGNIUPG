table 37079310 "ESL SQL Object Name"
{
    Caption = 'SQL Object Name';
    DataPerCompany = false;

    fields
    {
        field(1; "SQL Object Name"; Text[30])
        {
            Caption = 'SQL Object Name';
        }
        field(11; "Table ID"; Integer)
        {
            Caption = 'Table ID';
        }
        field(12; "Object Name"; Text[30])
        {
            Caption = 'Object Name';
        }
        field(13; "Object Caption"; Text[249])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE(Object Type=CONST(Table),
                                                                           Object ID=FIELD(Table ID)));
            Caption = 'Object Caption';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14;"Object Not Found";Boolean)
        {
            Caption = 'Object Not Found';
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"SQL Object Name")
        {
            Clustered = true;
        }
        key(Key2;"Table ID")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Text001: Label 'Inserted %1 %2';

    [Scope('Internal')]
    procedure PopulateWithAllTables(ShowStatus: Boolean)
    var
        "Object": Record "2000000001";
        ESSQLObjectName: Record "37079310";
        TempTableName: Text[30];
        Inserted: Integer;
    begin
        Object.RESET;
        Object.SETRANGE(Type,Object.Type::Table);
        IF Object.FIND('-') THEN
          REPEAT
            TempTableName := CONVERTSTR(Object.Name,'./\','___');
            IF NOT ESSQLObjectName.GET(TempTableName) THEN BEGIN
              ESSQLObjectName.INIT;
              ESSQLObjectName."SQL Object Name" := TempTableName;
              ESSQLObjectName."Table ID" := Object.ID;
              ESSQLObjectName."Object Name" := Object.Name;
              ESSQLObjectName.INSERT(TRUE);

              Inserted := Inserted + 1;
            END;
          UNTIL Object.NEXT = 0;

        IF ShowStatus THEN
          MESSAGE(Text001,Inserted,TABLECAPTION);
    end;
}

