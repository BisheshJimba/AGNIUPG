table 33019852 "PDI Line"
{
    DataPerCompany = false;

    fields
    {
        field(1; "PDI No."; Code[20])
        {
        }
        field(2; "Damage Remark"; Option)
        {
            OptionCaption = ' ,Transporter Sheet,In Transit Brj to Ktm,Within Office Premises,In Transit RXL to BRJ,In Transit BHRW to BRJ';
            OptionMembers = " ","Transporter Sheet","In Transit Brj to Ktm","Within Office Premises","In Transit RXL to BRJ","In Transit BHRW to BRJ";
        }
        field(3; "Damage Details"; Text[250])
        {
        }
        field(4; "Repair Type"; Option)
        {
            OptionCaption = ' ,Item,Labor,Ext. Service';
            OptionMembers = " ",Item,Labor,"Ext. Service";
        }
        field(5; "No."; Code[20])
        {
            TableRelation = IF (Repair Type=FILTER(Item)) Item WHERE (Item Type=CONST(Item))
                            ELSE IF (Repair Type=FILTER(Labor)) "Service Labor"
                            ELSE IF (Repair Type=FILTER(Ext. Service)) "External Service";

            trigger OnLookup()
            begin
                CASE "Repair Type" OF
                 "Repair Type"::" ":
                  BEGIN
                   StdTxt.RESET;
                   IF LookUpMgt.LookUpStandardText(StdTxt,"No.") THEN
                    VALIDATE("No.",StdTxt.Code);
                  END;

                 "Repair Type"::Item:
                  BEGIN

                   ItemRec.RESET;
                   ItemRec.SETFILTER("Model Filter 1",'%1','*'+PDIHdr.Model+'*');
                   IF LookUpMgt.LookUpItemREZ(ItemRec,"No.") THEN
                    VALIDATE("No.",ItemRec."No.");
                  END;



                 "Repair Type"::Labor:
                  BEGIN
                   ServLabor.RESET;
                   ServLabor.SETCURRENTKEY("Make Code");
                   ServLabor.SETFILTER("Make Code",'%1|''''',PDIHdr.Make);
                   ServLabor.SETFILTER("Model Code",'%1''''',PDIHdr.Model);
                   ServLabor.SETFILTER("Model Version No.",'%1''''',PDIHdr."Model Version No.");
                   IF LookUpMgt.LookUpLabor(ServLabor,"No.") THEN
                    VALIDATE("No.",ServLabor."No.");
                  END;
                END;
            end;

            trigger OnValidate()
            begin
                IF "No." = '' THEN EXIT;

                CASE "Repair Type" OF
                  "Repair Type"::" ":
                    BEGIN
                      StdTxt.GET("No.");
                      Description := StdTxt.Description;

                    END;
                  "Repair Type"::Item:
                    BEGIN
                      ItemRec.GET("No.");
                      Description := ItemRec.Description;
                      "Unit of Measure" := ItemRec."Base Unit of Measure";
                    END;
                  "Repair Type"::Labor:
                    BEGIN
                      ServLabor.GET("No.");
                      Description := ServLabor.Description;
                      "Unit of Measure" := ServLabor."Base Unit of Measure";
                    END;
                  "Repair Type"::"Ext. Service":
                    BEGIN
                      ExtService.GET("No.");
                      Description := ExtService.Description;
                      "Unit of Measure" := ExtService."Unit of Measure Code";
                    END;
                END;
            end;
        }
        field(6;Description;Text[50])
        {
            FieldClass = Normal;
        }
        field(7;"Claim to";Option)
        {
            OptionCaption = ' ,M&M,Agent,Insurance,Agni Expenses';
            OptionMembers = " ","M&M",Agent,Insurance,"Agni Expenses";
        }
        field(8;"Claim Details";Text[250])
        {
        }
        field(9;Quantity;Decimal)
        {
        }
        field(10;Rate;Decimal)
        {
        }
        field(11;"Line No.";Integer)
        {
        }
        field(12;"Unit of Measure";Code[10])
        {
        }
        field(13;"Transporter Name";Text[50])
        {
        }
        field(14;"Consignment No.";Integer)
        {
            BlankZero = true;
        }
    }

    keys
    {
        key(Key1;"PDI No.","Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        StdTxt: Record "7";
        ItemRec: Record "27";
        ServLabor: Record "25006121";
        ExtService: Record "25006133";
        PDIHdr: Record "33019851";
        LookUpMgt: Codeunit "25006003";
}

