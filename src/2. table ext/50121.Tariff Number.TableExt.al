tableextension 50121 tableextension50121 extends "Tariff Number"
{
    fields
    {

        //Unsupported feature: Code Insertion on ""No."(Field 1)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
        /*
        InvSetup.GET();
        IF NOT CompareHSCode("No.", InvSetup."HS Code Format") THEN
            ERROR('Invalid Format!');
        */
        //end;

        //Unsupported feature: Property Deletion (Numeric) on ""No."(Field 1)".

        field(4; "Show HS Code"; Code[20])
        {
        }
    }


    //Unsupported feature: Code Insertion on "OnInsert".

    //trigger OnInsert()
    //begin
    /*
    InvSetup.GET();
    "Show HS Code" := COPYSTR("No.", 1, InvSetup."HS Code Prefix Length");
    */
    //end;


    //Unsupported feature: Code Insertion on "OnRename".

    //trigger OnRename()
    //begin
    /*
    IF (Rec."No." <> xRec."No.") AND (Rec."No." <> '') THEN BEGIN
        InvSetup.GET();
        "Show HS Code" := COPYSTR("No.", 1, InvSetup."HS Code Prefix Length");
    END;
    */
    //end;

    procedure CompareHSCode(CompareCode: Text[20]; Format: Text[20]): Boolean
    var
        i: Integer;
        Cf: Text[1];
        Ce: Text[1];
        Check: Boolean;
        Text005: Label 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    begin
        Check := TRUE;
        IF STRLEN(CompareCode) = STRLEN(Format) THEN
            FOR i := 1 TO STRLEN(CompareCode) DO BEGIN
                Cf := COPYSTR(Format, i, 1);
                Ce := COPYSTR(CompareCode, i, 1);
                CASE Cf OF
                    '#':
                        IF NOT ((Ce >= '0') AND (Ce <= '9')) THEN
                            Check := FALSE;
                    '@':
                        IF STRPOS(Text005, UPPERCASE(Ce)) = 0 THEN
                            Check := FALSE;
                    ELSE
                        IF NOT ((Cf = Ce) OR (Cf = '?')) THEN
                            Check := FALSE
                END;
            END
        ELSE
            Check := FALSE;
        EXIT(Check);
    end;

    var
        InvSetup: Record "313";
        SysMgt: Codeunit "50014";
}

