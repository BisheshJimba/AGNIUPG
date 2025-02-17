table 25006060 Picture
{
    // 31.07.2013 EDMS P15
    //   * fix of No Series OnInsert (it worked with Manual allowed only)


    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
        }
        field(10; "Source Type"; Integer)
        {
            Caption = 'Source Type';
        }
        field(11; "Source Subtype"; Option)
        {
            Caption = 'Source Subtype';
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
        }
        field(12; "Source ID"; Code[20])
        {
            Caption = 'Source ID';
        }
        field(13; "Source Ref. No."; Integer)
        {
            Caption = 'Source Ref. No.';
        }
        field(20; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(30; Imported; Boolean)
        {
            Caption = 'Imported';
            Editable = false;
            FieldClass = Normal;
        }
        field(40; Default; Boolean)
        {
            Caption = 'Default';

            trigger OnValidate()
            var
                Picture3: Record "25006060";
                PictDefaultID: Code[20];
            begin
                IF xRec.Default <> Rec.Default THEN
                    IF Default = TRUE THEN BEGIN
                        PictDefaultID := GetPictDefaultID;
                        IF Picture3.GET(PictDefaultID) THEN BEGIN
                            Picture3.Default := FALSE;
                            Picture3.CALCFIELDS(BLOB);
                            Picture3.MODIFY;
                        END;
                    END ELSE BEGIN    //FALSE
                        MESSAGE(Text002, FIELDCAPTION("Source Type"), "Source Type", FIELDCAPTION("Source Subtype"), "Source Subtype",
                          FIELDCAPTION("Source ID"), "Source ID", FIELDCAPTION("Source Ref. No."), "Source Ref. No.");
                        Default := xRec.Default;
                    END;
            end;
        }
        field(50; BLOB; BLOB)
        {
            Caption = 'BLOB';
            SubType = Bitmap;

            trigger OnValidate()
            begin
                IF Rec.BLOB.HASVALUE THEN
                    Imported := TRUE
                ELSE
                    Imported := FALSE;
            end;
        }
        field(90; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Source Type", "Source Subtype", "Source ID", "Source Ref. No.", "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        IF (Default = TRUE) AND (COUNT > 1) THEN
            ERROR(Text002, FIELDCAPTION("Source Type"), "Source Type", FIELDCAPTION("Source Subtype"), "Source Subtype",
                FIELDCAPTION("Source ID"), "Source ID", FIELDCAPTION("Source Ref. No."), "Source Ref. No.");
    end;

    trigger OnInsert()
    var
        SerialNos: Code[20];
    begin
        IF "No." = '' THEN BEGIN
            GetPictureMgtSetup;
            PictureMgtSetup.TESTFIELD(Code);
            //NoSeriesMgt.InitSeries(PictureMgtSetup."Picture Nos.",xRec."No. Series",0D,"No.","No. Series");
            SerialNos := PictureMgtSetup.Code;
            //MESSAGE("No.");
            NoSeriesMgt.InitSeries(SerialNos, SerialNos, 0D, "No.", SerialNos);
        END;
        IF GetPictDefaultID = '' THEN   //means no Default yet
            Default := TRUE;
    end;

    trigger OnModify()
    begin
        IF (xRec."Source Type" <> Rec."Source Type") OR (xRec."Source Subtype" <> Rec."Source Subtype") OR
          (xRec."Source Ref. No." <> Rec."Source Ref. No.") OR (xRec."Source ID" <> Rec."Source ID") THEN
            IF GetPictDefaultID = '' THEN   //means no Default yet
                Default := TRUE;

        VALIDATE(BLOB);
    end;

    var
        PictureMgtSetup: Record "25006020";
        PictureGlobal: Record "25006060";
        NoSeriesMgt: Codeunit "396";
        Text001: Label 'The Object Picture %1 already exists.';
        HasPictureMgtSetup: Boolean;
        Text002: Label 'You must set another Default Picture for %1: %2, %3: %4, %5: %6, %7: %8. ';

    [Scope('Internal')]
    procedure AssistEdit(OldPicture: Record "25006060"): Boolean
    var
        Picture2: Record "25006060";
    begin
        GetPictureMgtSetup;
        PictureMgtSetup.TESTFIELD(Code);
        IF NoSeriesMgt.SelectSeries(PictureMgtSetup.Code, xRec."No. Series", "No. Series") THEN BEGIN
            NoSeriesMgt.SetSeries("No.");
            EXIT(TRUE);
        END;
    end;

    [Scope('Internal')]
    procedure InitRecord()
    var
        FieldVal: Text[100];
    begin
        NoSeriesMgt.SetDefaultSeries("No. Series", PictureMgtSetup.Code);
    end;

    [Scope('Internal')]
    procedure PopulateSourceFields()
    var
        FieldVal: Text[100];
    begin
        //31.07.2013 EDMS P15>>
        // property PopulateAllFields - emulation
        //MESSAGE('No.-' + "No.");
        FieldVal := GETFILTER("Source Type");      //Integer
        //MESSAGE('SourceType-' + FieldVal);
        EVALUATE("Source Type", FieldVal);  // add validation further

        FieldVal := GETFILTER("Source Subtype");   //Option
        //MESSAGE('SourceSubType-' + FieldVal);
        EVALUATE("Source Subtype", FieldVal);  // add validation further

        FieldVal := GETFILTER("Source ID");
        //MESSAGE('Source ID-' + FieldVal);
        "Source ID" := FieldVal;  // add validation further

        FieldVal := GETFILTER("Source Ref. No.");  //Integer
        //MESSAGE('Source Ref. No.-' + FieldVal);
        EVALUATE("Source Ref. No.", FieldVal);  // add validation further


        //MODIFY;
        //31.07.2013 EDMS P15<<
    end;

    local procedure TestNoSeries(): Boolean
    begin
        PictureMgtSetup.TESTFIELD(Code);
    end;

    [Scope('Internal')]
    procedure GetPictureMgtSetup()
    begin
        IF NOT HasPictureMgtSetup THEN BEGIN
            PictureMgtSetup.GET;
            HasPictureMgtSetup := TRUE;
        END;
    end;

    [Scope('Internal')]
    procedure GetPictDefaultID(): Code[20]
    var
        Picture2: Record "25006060";
    begin
        Picture2.RESET;
        Picture2.COPYFILTERS(Rec);
        Picture2.SETRANGE(Default, TRUE);
        IF Picture2.FINDFIRST THEN
            EXIT(Picture2."No.")
        ELSE
            EXIT('');
    end;
}

