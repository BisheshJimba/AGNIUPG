table 25006175 "Service Labor Text"
{
    Caption = 'Service Labor Text';
    LookupPageID = 25006250;

    fields
    {
        field(10; "Service Labor No."; Code[20])
        {
            Caption = 'Service Labor No.';
            TableRelation = "Service Labor";
        }
        field(20; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(30; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(40; "Description 3"; Text[50])
        {
            Caption = 'Description 3';
        }
        field(50; "Description 4"; Text[50])
        {
            Caption = 'Description 4';
        }
        field(25006800; "Variable Field 25006800"; Code[20])
        {
            CaptionClass = '7,25006175,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                IF ServiceLabor.GET("Service Labor No.") THEN;
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions, DATABASE::"Service Labor Text", FIELDNO("Variable Field 25006800"),
                  ServiceLabor."Make Code", "Variable Field 25006800") THEN BEGIN
                    VALIDATE("Variable Field 25006800", VFOptions.Code);
                END;
            end;
        }
        field(25006801; "Variable Field 25006801"; Code[20])
        {
            CaptionClass = '7,25006175,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "25006007";
            begin
                IF ServiceLabor.GET("Service Labor No.") THEN;
                VFOptions.RESET;
                IF cuLookupMgt.LookUpVariableField(VFOptions, DATABASE::"Service Labor Text", FIELDNO("Variable Field 25006801"),
                  ServiceLabor."Make Code", "Variable Field 25006801") THEN BEGIN
                    VALIDATE("Variable Field 25006801", VFOptions.Code);
                END;
            end;
        }
    }

    keys
    {
        key(Key1; "Service Labor No.", "Variable Field 25006800", "Variable Field 25006801")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        cuVFMgt: Codeunit "25006004";
        cuLookupMgt: Codeunit "25006003";
        ServiceLabor: Record "25006121";

    [Scope('Internal')]
    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        IF ServiceLabor.GET("Service Labor No.") THEN;
        CLEAR(cuVFMgt);
        EXIT(cuVFMgt.IsVFActive(DATABASE::"Service Labor Text", intFieldNo));
    end;
}

