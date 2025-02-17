table 25006190 "Common Log Entry"
{
    // 12.01.2015 EB.P7 #Username length EDMS
    //   User ID Field length changed to Code(50)


    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2; "Date and Time"; DateTime)
        {
            Caption = 'Date and Time';
        }
        field(3; Time; Time)
        {
            Caption = 'Time';
        }
        field(4; "User ID"; Code[50])
        {
            Caption = 'User ID';
        }
        field(5; "Table No."; Integer)
        {
            Caption = 'Table No.';
            TableRelation = AllObj."Object ID" WHERE(Object Type=CONST(Table));
        }
        field(6; "Table Name"; Text[80])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE(Object Type=CONST(Table),
                                                                           Object ID=FIELD(Table No.)));
            Caption = 'Table Name';
            FieldClass = FlowField;
        }
        field(7;"Field No.";Integer)
        {
            Caption = 'Field No.';
            TableRelation = Field.No. WHERE (TableNo=FIELD(Table No.));
        }
        field(8;"Field Name";Text[80])
        {
            CalcFormula = Lookup(Field."Field Caption" WHERE (TableNo=FIELD(Table No.),
                                                              No.=FIELD(Field No.)));
            Caption = 'Field Name';
            FieldClass = FlowField;
        }
        field(9;"Type of Change";Option)
        {
            Caption = 'Type of Change';
            OptionCaption = 'Insertion,Modification,Deletion';
            OptionMembers = Insertion,Modification,Deletion;
        }
        field(10;"Old Value";Text[250])
        {
            Caption = 'Old Value';
        }
        field(11;"New Value";Text[250])
        {
            Caption = 'New Value';
        }
        field(12;"Primary Key";Text[250])
        {
            Caption = 'Primary Key';
        }
        field(13;"Primary Key Field 1 No.";Integer)
        {
            Caption = 'Primary Key Field 1 No.';
            TableRelation = Field.No. WHERE (TableNo=FIELD(Table No.));
        }
        field(14;"Primary Key Field 1 Name";Text[80])
        {
            CalcFormula = Lookup(Field."Field Caption" WHERE (TableNo=FIELD(Table No.),
                                                              No.=FIELD(Primary Key Field 1 No.)));
            Caption = 'Primary Key Field 1 Name';
            FieldClass = FlowField;
        }
        field(15;"Primary Key Field 1 Value";Text[50])
        {
            Caption = 'Primary Key Field 1 Value';
        }
        field(16;"Primary Key Field 2 No.";Integer)
        {
            Caption = 'Primary Key Field 2 No.';
            TableRelation = Field.No. WHERE (TableNo=FIELD(Table No.));
        }
        field(17;"Primary Key Field 2 Name";Text[80])
        {
            CalcFormula = Lookup(Field."Field Caption" WHERE (TableNo=FIELD(Table No.),
                                                              No.=FIELD(Primary Key Field 2 No.)));
            Caption = 'Primary Key Field 2 Name';
            FieldClass = FlowField;
        }
        field(18;"Primary Key Field 2 Value";Text[50])
        {
            Caption = 'Primary Key Field 2 Value';
        }
        field(19;"Primary Key Field 3 No.";Integer)
        {
            Caption = 'Primary Key Field 3 No.';
            TableRelation = Field.No. WHERE (TableNo=FIELD(Table No.));
        }
        field(20;"Primary Key Field 3 Name";Text[80])
        {
            CalcFormula = Lookup(Field."Field Caption" WHERE (TableNo=FIELD(Table No.),
                                                              No.=FIELD(Primary Key Field 3 No.)));
            Caption = 'Primary Key Field 3 Name';
            FieldClass = FlowField;
        }
        field(21;"Primary Key Field 3 Value";Text[50])
        {
            Caption = 'Primary Key Field 3 Value';
        }
        field(22;"Primary Key Field 4 No.";Integer)
        {
            Caption = 'Primary Key Field 4 No.';
            TableRelation = Field.No. WHERE (TableNo=FIELD(Table No.));
        }
        field(23;"Primary Key Field 4 Name";Text[80])
        {
            CalcFormula = Lookup(Field."Field Caption" WHERE (TableNo=FIELD(Table No.),
                                                              No.=FIELD(Primary Key Field 4 No.)));
            Caption = 'Primary Key Field 4 Name';
            FieldClass = FlowField;
        }
        field(24;"Primary Key Field 4 Value";Text[50])
        {
            Caption = 'Primary Key Field 4 Value';
        }
        field(100;"Object Type";Option)
        {
            OptionMembers = "Table",Form,"Report",Dataport,"XMLport","Codeunit",MenuSuite,"Page";
        }
        field(101;"Object No.";Integer)
        {
        }
        field(110;"Start Info";Text[100])
        {
        }
        field(120;"Processing Info";Text[100])
        {
        }
        field(130;"Processing Value";Text[30])
        {
        }
        field(140;"End Info";Text[100])
        {
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
            Clustered = true;
        }
        key(Key2;"Table No.","Primary Key Field 1 No.")
        {
        }
        key(Key3;"Table No.","Date and Time")
        {
        }
    }

    fieldgroups
    {
    }

    var
        ServiceMgtSetup: Record "25006120";
        TempField: Record "2000000041" temporary;

    [Scope('Internal')]
    procedure InsertLogEntry(Type: Integer;ObjectID: Integer;CommonLogEntryPar: Record "25006190";var FldRef: FieldRef;var xFldRef: FieldRef;var RecRef: RecordRef;TypeOfChange: Option Insertion,Modification,Deletion;RunModeFlags: Integer)
    var
        CommonLogEntry: Record "25006190";
        FlagsArray: array [16] of Boolean;
        KeyFldRef: FieldRef;
        KeyRef1: KeyRef;
        i: Integer;
        FldRefDefined: Boolean;
    begin
        AdjustFlagsToArray(RunModeFlags, FlagsArray);
        //FIRST FLAD means is fildref initialised
        FldRefDefined := FlagsArray[1];
        CommonLogEntry.INIT;
        CommonLogEntry.TRANSFERFIELDS(CommonLogEntryPar);
        CommonLogEntry.VALIDATE("Date and Time", CURRENTDATETIME);
        CommonLogEntry.VALIDATE(Time, DT2TIME(CommonLogEntry."Date and Time"));
        CommonLogEntry.VALIDATE("User ID", USERID);
        CommonLogEntry.VALIDATE("Object Type", Type);
        CommonLogEntry.VALIDATE("Object No.", ObjectID);

        CommonLogEntry."Table No." := RecRef.NUMBER;
        IF FldRefDefined THEN
          CommonLogEntry."Field No." := FldRef.NUMBER;
        CommonLogEntry."Type of Change" := TypeOfChange;

        IF TypeOfChange <> TypeOfChange::Insertion THEN
          IF FldRefDefined THEN
            CommonLogEntry."Old Value" := FormatValue(xFldRef,RecRef.NUMBER);
        IF TypeOfChange <> TypeOfChange::Deletion THEN
          IF FldRefDefined THEN
            CommonLogEntry."New Value" := FormatValue(FldRef,RecRef.NUMBER);

        KeyRef1 := RecRef.KEYINDEX(1);
        FOR i := 1 TO KeyRef1.FIELDCOUNT DO BEGIN
          KeyFldRef := KeyRef1.FIELDINDEX(i);
          IF i = 1 THEN
            CommonLogEntry."Primary Key" :=
              STRSUBSTNO('%1=%2',KeyFldRef.CAPTION,FormatValue(KeyFldRef,RecRef.NUMBER))
          ELSE
            IF MAXSTRLEN(CommonLogEntry."Primary Key") >
              STRLEN(CommonLogEntry."Primary Key") +
              STRLEN(STRSUBSTNO(', %1=%2',KeyFldRef.CAPTION,FormatValue(KeyFldRef,RecRef.NUMBER)))
            THEN
              CommonLogEntry."Primary Key" :=
                COPYSTR(
                  CommonLogEntry."Primary Key" +
                  STRSUBSTNO(', %1=%2',KeyFldRef.CAPTION,FormatValue(KeyFldRef,RecRef.NUMBER)),
                  1,MAXSTRLEN(CommonLogEntry."Primary Key"));

          CASE i OF
            1:
              BEGIN
                CommonLogEntry."Primary Key Field 1 No." := KeyFldRef.NUMBER;
                CommonLogEntry."Primary Key Field 1 Value" := FormatValue(KeyFldRef,RecRef.NUMBER);
              END;
            2:
              BEGIN
                CommonLogEntry."Primary Key Field 2 No." := KeyFldRef.NUMBER;
                CommonLogEntry."Primary Key Field 2 Value" := FormatValue(KeyFldRef,RecRef.NUMBER);
              END;
            3:
              BEGIN
                CommonLogEntry."Primary Key Field 3 No." := KeyFldRef.NUMBER;
                CommonLogEntry."Primary Key Field 3 Value" := FormatValue(KeyFldRef,RecRef.NUMBER);
              END;
            4:
              BEGIN
                CommonLogEntry."Primary Key Field 4 No." := KeyFldRef.NUMBER;
                CommonLogEntry."Primary Key Field 4 Value" := FormatValue(KeyFldRef,RecRef.NUMBER);
              END;
          END;
        END;
        CommonLogEntry.INSERT(TRUE);
    end;

    [Scope('Internal')]
    procedure FormatValue(var FldRef: FieldRef;TableNumber: Integer): Text[250]
    var
        "Field": Record "2000000041";
        OptionNo: Integer;
        OptionStr: Text[1024];
        i: Integer;
    begin
        GetField(TableNumber,FldRef.NUMBER,Field);
        IF Field.Type = Field.Type::Option THEN BEGIN
          OptionNo := FldRef.VALUE;
          OptionStr := FORMAT(FldRef.OPTIONCAPTION);
          FOR i := 1 TO OptionNo DO
            OptionStr := COPYSTR(OptionStr,STRPOS(OptionStr,',') + 1);
          IF STRPOS(OptionStr,',') > 0 THEN
            IF STRPOS(OptionStr,',') = 1 THEN
              OptionStr := ''
            ELSE
              OptionStr := COPYSTR(OptionStr,1,STRPOS(OptionStr,',') - 1);
          EXIT(OptionStr);
        END ELSE
          EXIT(FORMAT(FldRef.VALUE));
    end;

    local procedure GetField(TableNumber: Integer;FieldNumber: Integer;var Field2: Record "2000000041")
    var
        "Field": Record "2000000041";
    begin
        IF NOT TempField.GET(TableNumber,FieldNumber) THEN BEGIN
          Field.GET(TableNumber,FieldNumber);
          TempField := Field;
          TempField.INSERT;
        END;
        Field2 := TempField;
    end;

    [Scope('Internal')]
    procedure "--SMALL TECHN--"()
    begin
    end;

    [Scope('Internal')]
    procedure CutNextBit(var Flags: Integer) RetValue: Boolean
    begin
        RetValue := ((Flags MOD 2) > 0);
        Flags := Flags DIV 2;
        EXIT(RetValue);
    end;

    [Scope('Internal')]
    procedure AdjustFlagsToArray(Flags: Integer;var ArrayEDMS: array [16] of Boolean)
    var
        i: Integer;
    begin
        FOR i := 1 TO 16 DO BEGIN
          ArrayEDMS[i] := CutNextBit(Flags);
        END;
    end;
}

