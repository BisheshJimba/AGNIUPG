table 33019871 "Value Added Services"
{

    fields
    {
        field(1; "Membership Card No."; Code[20])
        {
        }
        field(2; Type; Option)
        {
            OptionCaption = ' ,Labor';
            OptionMembers = " ",Labor;
        }
        field(3; "No."; Code[20])
        {

            trigger OnLookup()
            begin
                CASE Type OF
                    Type::" ":
                        BEGIN
                            StandardText.RESET;
                            IF LookUpMgt.LookUpStandardText(StandardText, "No.") THEN
                                VALIDATE("No.", StandardText.Code);
                        END;
                    /*
                   Type::Labor:
                    BEGIN
                     GLAccount.RESET;
                     IF LookUpMgt.LookUpGLAccount(labor,"No.") THEN
                      VALIDATE("No.",GLAccount."No.");
                    END;
                    */
                    Type::"2":
                        BEGIN

                            Item.RESET;
                            IF LookUpMgt.LookUpItemREZ(Item, "No.") THEN
                                VALIDATE("No.", Item."No.");
                        END;

                    Type::Labor:
                        BEGIN
                            Labor.RESET;
                            Labor.SETCURRENTKEY("Make Code");
                            IF LookUpMgt.LookUpLabor(Labor, "No.") THEN
                                VALIDATE("No.", Labor."No.");
                        END;

                    //****SM filtering ext. service as per acc. center
                    Type::"4":
                        BEGIN
                            MembershipHdr.RESET;
                            IF (MembershipHdr."Accountability Center" = 'BID') OR (MembershipHdr."Accountability Center" = 'BRR') THEN
                                ExternalService.SETRANGE("Accountability Center", 'BID')
                            ELSE BEGIN
                                ExternalService.SETRANGE("Accountability Center", MembershipHdr."Accountability Center");
                            END;
                            IF LookUpMgt.LookUpExternalService(ExternalService, "No.") THEN
                                VALIDATE("No.", ExternalService."No.");
                        END;
                END;
                //****SM filtering ext. service as per acc. center

            end;

            trigger OnValidate()
            var
                Markup: Record "25006741";
                ItemDisc: Record "7004";
                LabTransl: Record "25006127";
                ItemTransl: Record "30";
                VariableFieldUsage: Record "25006006";
                NewItemNo: Code[20];
                PrepaymentMgt: Codeunit "441";
            begin
                IF "No." = '' THEN EXIT;

                CASE Type OF
                    Type::" ":
                        BEGIN
                            StdTxt.GET("No.");
                            Description := StdTxt.Description;
                        END;
                    /*
                    Type::Labor:
                     BEGIN
                      GLAcc.GET("No.");
                      GLAcc.CheckGLAcc;
                      GLAcc.TESTFIELD("Direct Posting",TRUE);
                      Description := GLAcc.Name;
                     END;
                     */
                    Type::"2":
                        BEGIN
                            GetItem;
                            Item.TESTFIELD(Blocked, FALSE);
                            Item.TESTFIELD("Inventory Posting Group");
                            Item.TESTFIELD("Gen. Prod. Posting Group");
                            Description := Item.Description;
                            "Description 2" := Item."Description 2";
                        END;

                    Type::Labor:
                        BEGIN
                            Labor.GET("No.");
                            Labor.TESTFIELD(Blocked, FALSE);
                            Labor.TESTFIELD("Gen. Prod. Posting Group");
                            Labor.TESTFIELD("VAT Prod. Posting Group");
                            Description := Labor.Description;
                            "Description 2" := Labor."Description 2";
                        END;

                    Type::"4":
                        BEGIN
                            ExtServ.GET("No.");
                            ExtServ.TESTFIELD(Blocked, FALSE);
                            ExtServ.TESTFIELD("Gen. Prod. Posting Group");
                            ExtServ.TESTFIELD("VAT Prod. Posting Group");
                            ExtServ.TESTFIELD("Internal Service", FALSE);
                            Description := ExtServ.Description;
                            "Description 2" := ExtServ."Description 2";
                        END;
                END;

            end;
        }
        field(4; Description; Text[50])
        {
        }
        field(5; "Description 2"; Text[50])
        {
        }
        field(6; "Valid Quantity"; Decimal)
        {
        }
        field(7; "Utilised Quantity"; Integer)
        {
            CalcFormula = Count("Posted Serv. Order Line" WHERE(Membership No.=FIELD(Membership Card No.),
                                                                 Type=FILTER(Labor),
                                                                 No.=FIELD(No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(8;"Line No.";Integer)
        {
        }
    }

    keys
    {
        key(Key1;"Membership Card No.","Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        StdTxt: Record "7";
        GLAcc: Record "15";
        Item: Record "27";
        Labor: Record "25006121";
        ExtServ: Record "25006133";
        StandardText: Record "7";
        LookUpMgt: Codeunit "25006003";
        GLAccount: Record "15";
        ExternalService: Record "25006133";
        MembershipHdr: Record "33019864";

    local procedure GetItem()
    begin
        TESTFIELD("No.");
        IF "No." <> Item."No." THEN
          Item.GET("No.");
    end;
}

