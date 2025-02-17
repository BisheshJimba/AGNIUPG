table 33020156 "SSI Header"
{

    fields
    {
        field(1; "Prospect No."; Code[20])
        {
            TableRelation = Contact;
        }
        field(3; "Prospect Line No."; Integer)
        {
        }
        field(4; "Model No."; Code[20])
        {
            TableRelation = Model.Code WHERE(Make Code=FIELD(Make));
        }
        field(5;"Model Version No.";Code[20])
        {

            trigger OnLookup()
            begin
                //Lookup Model Version.
                GblItem.RESET;
                IF GblLookupMgt.LookUpModelVersion(GblItem,"Model Version No.",Make,"Model No.") THEN
                 VALIDATE("Model Version No.",GblItem."No.");
            end;

            trigger OnValidate()
            begin
                //Code to bring model version name.
                GblItem.RESET;
                GblItem.SETRANGE("No.","Model Version No.");
                IF GblItem.FIND('-') THEN
                  "Model Version Name" := GblItem.Description;
            end;
        }
        field(6;"Model Version Name";Text[50])
        {
        }
        field(7;"Registration No.";Code[20])
        {
        }
        field(8;"Bill No.";Code[20])
        {
        }
        field(9;"Birthday Date";Date)
        {
        }
        field(10;"Anniversary Date";Date)
        {
        }
        field(11;"Recom. 1 Addr.";Text[50])
        {
        }
        field(12;"Recom. 1 Mobile";Text[30])
        {
        }
        field(13;"Recom. 2 Addr.";Text[50])
        {
        }
        field(14;"Recom. 2 Mobile";Text[30])
        {
        }
        field(15;"Definitely Recom.";Boolean)
        {
        }
        field(16;"SW Recom.";Boolean)
        {
        }
        field(17;"MN Recom.";Boolean)
        {
        }
        field(18;Make;Code[20])
        {
            TableRelation = Make;
        }
    }

    keys
    {
        key(Key1;"Prospect No.","Prospect Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        gblSSILine.RESET;
        gblSSILine.SETRANGE("Prospect No.","Prospect No.");
        gblSSILine.SETRANGE("Prospect Line No.","Prospect Line No.");
        gblSSILine.DELETEALL;
    end;

    var
        GblLookupMgt: Codeunit "25006003";
        GblItem: Record "27";
        gblSSILine: Record "33020157";
        gblVhCRMMngt: Codeunit "33020142";
}

