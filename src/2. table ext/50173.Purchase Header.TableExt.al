tableextension 50173 tableextension50173 extends "Purchase Header"
{
    // 08.05.2017 EB.P7
    //   Modified function fSetUserDefaultValues
    // 
    // 16.03 2016 EB.P7 Branch Setup
    //   Modified fSetUserDefaultValues(), Usert Profile Setup to Branch Profile Setup
    //   Modified GetDefaultVendor(), Usert Profile Setup to Branch Profile Setup
    // 
    // 12.06.2015 EB.P30 #T042
    //   Modified function:
    //     CreateDim
    //   Modified CreateDim calls because of added parameter
    //   Modified trigger:
    //     Dela Type - OnValidate
    // 
    // 
    // 16.04.2015 EB.P7 #Merge
    //   CreateDimSetForPrepmtAccDefaultDim() Modified to Call CreateDim with suficient params.
    // 
    // 10.03.2015 EDMS P21
    //   Modified procedure:
    //     CreateDim
    //   Modified CreateDim calls because of added parameter
    //   Modified trigger:
    //     Location Code - OnValidate
    // 
    // 09.06.2014 Elva Baltic P8 #F0001 EDMS7.10
    //   Added field:
    //     "Ordering Price Type Code"
    // 
    // 26.03.2014 Elva Baltic P18 #F011 #MMG7.00
    //   Added Code To "Vehicle Serial No. - OnValidate()"
    // 
    // 25.10.2013 EDMS P8
    //   * Added use of Vehicle default dimension
    // 
    // 13.06.2007. EDMS P2
    //   * Added functions PLines, AddDim
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Pay-to Name"(Field 5)".


        //Unsupported feature: Property Modification (Data type) on ""Pay-to Name 2"(Field 6)".

        modify("Pay-to City")
        {
            TableRelation = IF (Pay-to Country/Region Code=CONST()) "Post Code".City
                            ELSE IF (Pay-to Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Pay-to Country/Region Code));
        }
        modify("Ship-to City")
        {
            TableRelation = IF (Ship-to Country/Region Code=CONST()) "Post Code".City
                            ELSE IF (Ship-to Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Ship-to Country/Region Code));
        }

        //Unsupported feature: Property Modification (Data type) on ""Posting Description"(Field 22)".


        //Unsupported feature: Property Insertion (Editable) on ""Location Code"(Field 28)".


        //Unsupported feature: Property Modification (CalcFormula) on "Comment(Field 46)".

        modify("Bal. Account No.")
        {
            TableRelation = IF (Bal. Account Type=CONST(G/L Account)) "G/L Account"
                            ELSE IF (Bal. Account Type=CONST(Bank Account)) "Bank Account";
        }

        //Unsupported feature: Property Modification (CalcFormula) on ""Recalculate Invoice Disc."(Field 56)".


        //Unsupported feature: Property Modification (CalcFormula) on "Amount(Field 60)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Amount Including VAT"(Field 61)".


        //Unsupported feature: Property Modification (Data type) on ""Buy-from Vendor Name"(Field 79)".


        //Unsupported feature: Property Modification (Data type) on ""Buy-from Vendor Name 2"(Field 80)".


        //Unsupported feature: Property Modification (Data type) on ""Buy-from Address 2"(Field 82)".

        modify("Buy-from City")
        {
            TableRelation = IF (Buy-from Country/Region Code=CONST()) "Post Code".City
                            ELSE IF (Buy-from Country/Region Code=FILTER(<>'')) "Post Code".City WHERE (Country/Region Code=FIELD(Buy-from Country/Region Code));
        }
        modify("Pay-to Post Code")
        {
            TableRelation = IF (Pay-to Country/Region Code=CONST()) "Post Code"
                            ELSE IF (Pay-to Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Pay-to Country/Region Code));
        }
        modify("Buy-from Post Code")
        {
            TableRelation = IF (Buy-from Country/Region Code=CONST()) "Post Code"
                            ELSE IF (Buy-from Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Buy-from Country/Region Code));
        }
        modify("Ship-to Post Code")
        {
            TableRelation = IF (Ship-to Country/Region Code=CONST()) "Post Code"
                            ELSE IF (Ship-to Country/Region Code=FILTER(<>'')) "Post Code" WHERE (Country/Region Code=FIELD(Ship-to Country/Region Code));
        }

        //Unsupported feature: Property Modification (OptionString) on "Status(Field 120)".


        //Unsupported feature: Property Modification (Editable) on ""Quote No."(Field 151)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Invoice Discount Amount"(Field 1305)".


        //Unsupported feature: Property Modification (CalcFormula) on ""No. of Archived Versions"(Field 5043)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Completely Received"(Field 5752)".


        //Unsupported feature: Property Modification (CalcFormula) on ""Pending Approvals"(Field 9001)".



        //Unsupported feature: Code Modification on ""Buy-from Vendor No."(Field 2).OnValidate".

        //trigger "(Field 2)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            InitRecOnVendUpdate;
            TESTFIELD(Status,Status::Open);
            IF ("Buy-from Vendor No." <> xRec."Buy-from Vendor No.") AND
            #4..37
            "VAT Country/Region Code" := Vend."Country/Region Code";
            "VAT Registration No." := Vend."VAT Registration No.";
            VALIDATE("Lead Time Calculation",Vend."Lead Time Calculation");
            "Responsibility Center" := UserSetupMgt.GetRespCenter(1,Vend."Responsibility Center");
            VALIDATE("Sell-to Customer No.",'');
            VALIDATE("Location Code",UserSetupMgt.GetLocation(1,Vend."Location Code","Responsibility Center"));

            IF "Buy-from Vendor No." = xRec."Pay-to Vendor No." THEN
              IF ReceivedPurchLinesExist OR ReturnShipmentExist THEN BEGIN
            #47..71

            IF NOT SkipBuyFromContact THEN
              UpdateBuyFromCont("Buy-from Vendor No.");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..40
            //"Responsibility Center" := UserSetupMgt.GetRespCenter(1,Vend."Responsibility Center");

            IF UserSetupMgt.DefaultResponsibility THEN BEGIN
              "Responsibility Center" := UserSetupMgt.GetRespCenter(1,Vend."Responsibility Center");
              VALIDATE("Location Code",UserSetupMgt.GetLocation(1,Vend."Location Code","Responsibility Center"));
            END
            ELSE BEGIN
              "Accountability Center" := UserSetupMgt.GetRespCenter(1,Vend."Accountability Center");
              VALIDATE("Location Code",UserSetupMgt.GetLocation(1,Vend."Location Code","Accountability Center"));
            END;

            VALIDATE("Sell-to Customer No.",'');
            //VALIDATE("Location Code",UserSetupMgt.GetLocation(1,Vend."Location Code","Responsibility Center"));
            #44..74

            //EDMS1.0.00 >>
            fSetUserDefaultValues;
            //EDMS1.0.00 <<


            {
            //Agile6.1.0>>
            //Calling function in Codeunit::33019810 to check for Vendor Levels. If is not of L1 then throws message.
            IF NOT ("Document Profile" IN ["Document Profile"::"Spare Parts Trade","Document Profile"::"Vehicles Trade",
                    "Document Profile"::Service]) THEN
              LclPrcDocMngt.checkVndLevelPrchHdr("Buy-from Vendor No.");
            //Agile6.1.0<<
            }
            */
        //end;


        //Unsupported feature: Code Modification on ""No."(Field 3).OnValidate".

        //trigger "(Field 3)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF "No." <> xRec."No." THEN BEGIN
              PurchSetup.GET;
              NoSeriesMgt.TestManual(GetNoSeriesCode);
              "No. Series" := '';
            END;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            IF "No." <> xRec."No." THEN BEGIN
              PurchSetup.GET;
              NoSeriesMgt.TestManual(GetNoSeriesCode2);
              "No. Series" := '';
            END;
            */
        //end;


        //Unsupported feature: Code Insertion (VariableCollection) on ""Pay-to Vendor No."(Field 4).OnValidate".

        //trigger (Variable: UserSetup)()
        //Parameters and return type have not been exported.
        //begin
            /*
            */
        //end;


        //Unsupported feature: Code Modification on ""Pay-to Vendor No."(Field 4).OnValidate".

        //trigger "(Field 4)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TESTFIELD(Status,Status::Open);
            IF (xRec."Pay-to Vendor No." <> "Pay-to Vendor No.") AND
               (xRec."Pay-to Vendor No." <> '')
            #4..40

            "Shipment Method Code" := Vend."Shipment Method Code";
            "Vendor Posting Group" := Vend."Vendor Posting Group";
            GLSetup.GET;
            IF GLSetup."Bill-to/Sell-to VAT Calc." = GLSetup."Bill-to/Sell-to VAT Calc."::"Bill-to/Pay-to No." THEN BEGIN
              "VAT Bus. Posting Group" := Vend."VAT Bus. Posting Group";
            #47..51
            "Currency Code" := Vend."Currency Code";
            "Invoice Disc. Code" := Vend."Invoice Disc. Code";
            "Language Code" := Vend."Language Code";
            "Purchaser Code" := Vend."Purchaser Code";
            VALIDATE("Payment Terms Code");
            VALIDATE("Prepmt. Payment Terms Code");
            VALIDATE("Payment Method Code");
            #59..70
              DATABASE::Vendor,"Pay-to Vendor No.",
              DATABASE::"Salesperson/Purchaser","Purchaser Code",
              DATABASE::Campaign,"Campaign No.",
              DATABASE::"Responsibility Center","Responsibility Center");

            IF (xRec."Buy-from Vendor No." = "Buy-from Vendor No.") AND
               (xRec."Pay-to Vendor No." <> "Pay-to Vendor No.")
            #78..81
              UpdatePayToCont("Pay-to Vendor No.");

            "Pay-to IC Partner Code" := Vend."IC Partner Code";
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..43

            //Agni.. 31/03/2013 Suman Maharjan to populate TDS Posting Group in Purchase order and Invoice
            "TDS Posting Group" := Vend."TDS Posting Group";
            //Agni.. 31/03/2013 Suman Maharjan

            #44..54

            //EDMS1.0.00 >>
            IF "Purchaser Code" = '' THEN
             "Purchaser Code" := Vend."Purchaser Code";
            //EDMS1.0.00 <<

            #56..73
              DATABASE::"Responsibility Center","Responsibility Center",
              DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
              DATABASE::Location,"Location Code",      // 10.03.2015 EDMS P21
              DATABASE::"Deal Type","Deal Type Code"   //12.06.2015 EB.P30 #042
              );


            //Sipradi-YS GEN6.1.0 25006145-1 BEGIN >> Get User Branch/Costcenter (Dimension)
            IF UserSetup.GET(USERID) THEN BEGIN
              VALIDATE("Shortcut Dimension 1 Code",UserSetup."Shortcut Dimension 1 Code");
              VALIDATE("Shortcut Dimension 2 Code",UserSetup."Shortcut Dimension 2 Code");
            END;
            //Sipradi-YS GEN6.1.0 25006145-1 END
            #75..84
            */
        //end;


        //Unsupported feature: Code Modification on ""Location Code"(Field 28).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TESTFIELD(Status,Status::Open);
            IF ("Location Code" <> xRec."Location Code") AND
               (xRec."Buy-from Vendor No." = "Buy-from Vendor No.")
            #4..12
              IF Location.GET("Location Code") THEN;
              "Inbound Whse. Handling Time" := Location."Inbound Whse. Handling Time";
            END;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..15

            // 10.03.2015 EDMS P21 >>
            CreateDim(
              DATABASE::Location,"Location Code",
              DATABASE::Vendor,"Pay-to Vendor No.",
              DATABASE::"Salesperson/Purchaser","Purchaser Code",
              DATABASE::Campaign,"Campaign No.",
              DATABASE::"Responsibility Center","Responsibility Center",
              DATABASE::Vehicle,"Vehicle Serial No.",
              DATABASE::"Deal Type","Deal Type Code"//, //12.06.2015 EB.P30 #042
              );
            // 10.03.2015 EDMS P21 <<
            */
        //end;


        //Unsupported feature: Code Modification on ""Shortcut Dimension 1 Code"(Field 29).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            GetPostingNoSeries;
            */
        //end;


        //Unsupported feature: Code Modification on ""Shortcut Dimension 2 Code"(Field 30).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            GetPostingNoSeries;
            */
        //end;


        //Unsupported feature: Code Modification on ""Purchaser Code"(Field 43).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            ApprovalEntry.SETRANGE("Table ID",DATABASE::"Purchase Header");
            ApprovalEntry.SETRANGE("Document Type","Document Type");
            ApprovalEntry.SETRANGE("Document No.","No.");
            #4..8
              DATABASE::"Salesperson/Purchaser","Purchaser Code",
              DATABASE::Vendor,"Pay-to Vendor No.",
              DATABASE::Campaign,"Campaign No.",
              DATABASE::"Responsibility Center","Responsibility Center");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..11
              DATABASE::"Responsibility Center","Responsibility Center",
              DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
              DATABASE::Location,"Location Code",      // 10.03.2015 EDMS P21
              DATABASE::"Deal Type","Deal Type Code"   //12.06.2015 EB.P30 #042
              );
            */
        //end;


        //Unsupported feature: Code Insertion on ""Vendor Order No."(Field 66)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //var
            //PurchLine: Record "39";
        //begin
            /*
            //EDMS1.0.00 >>
            PurchLine.RESET;
            PurchLine.SETRANGE("Document Type","Document Type");
            PurchLine.SETRANGE("Document No.","No.");
            IF NOT PurchLine.ISEMPTY THEN BEGIN
              IF NOT CONFIRM(tcDMS001) THEN
                EXIT;
              PurchLine.MODIFYALL("Vendor Order No.", "Vendor Order No.");
            END;
            //EDMS1.0.00 <<
            */
        //end;


        //Unsupported feature: Code Modification on ""Sell-to Customer No."(Field 72).OnValidate".

        //trigger "(Field 72)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF ("Document Type" = "Document Type"::Order) AND
               (xRec."Sell-to Customer No." <> "Sell-to Customer No.")
            THEN BEGIN
            #4..15
                  YouCannotChangeFieldErr,
                  FIELDCAPTION("Sell-to Customer No."));
            END;

            IF "Sell-to Customer No." = '' THEN
              VALIDATE("Location Code",UserSetupMgt.GetLocation(1,'',"Responsibility Center"))
            ELSE
              VALIDATE("Ship-to Code",'');
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..18
            {
            #20..23
            }

            IF "Sell-to Customer No." = '' THEN
              IF UserSetupMgt.DefaultResponsibility THEN
                VALIDATE("Location Code",UserSetupMgt.GetLocation(1,'',"Responsibility Center"))
              ELSE
                VALIDATE("Location Code",UserSetupMgt.GetLocation(1,'',"Accountability Center"))
            ELSE
              VALIDATE("Ship-to Code",'');
            */
        //end;


        //Unsupported feature: Code Modification on ""Posting No. Series"(Field 108).OnValidate".

        //trigger  Series"(Field 108)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF "Posting No. Series" <> '' THEN BEGIN
              PurchSetup.GET;
              TestNoSeries;
              NoSeriesMgt.TestSeries(GetPostingNoSeriesCode,"Posting No. Series");
            END;
            TESTFIELD("Posting No.",'');
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..3
              //NoSeriesMgt.TestSeries(GetPostingNoSeriesCode,"Posting No. Series");
              NoSeriesMgt.TestSeries("Posting No. Series","Posting No. Series");
            END;
            TESTFIELD("Posting No.",'');
            */
        //end;


        //Unsupported feature: Code Modification on ""Campaign No."(Field 5050).OnValidate".

        //trigger "(Field 5050)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            CreateDim(
              DATABASE::Campaign,"Campaign No.",
              DATABASE::Vendor,"Pay-to Vendor No.",
              DATABASE::"Salesperson/Purchaser","Purchaser Code",
              DATABASE::"Responsibility Center","Responsibility Center");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..4
              DATABASE::"Responsibility Center","Responsibility Center",
              DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
              DATABASE::Location,"Location Code",      // 10.03.2015 EDMS P21
              DATABASE::"Deal Type","Deal Type Code"   //12.06.2015 EB.P30 #042
              );
            */
        //end;


        //Unsupported feature: Code Modification on ""Responsibility Center"(Field 5700).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            TESTFIELD(Status,Status::Open);
            IF NOT UserSetupMgt.CheckRespCenter(1,"Responsibility Center") THEN
              ERROR(
            #4..18
              DATABASE::"Responsibility Center","Responsibility Center",
              DATABASE::Vendor,"Pay-to Vendor No.",
              DATABASE::"Salesperson/Purchaser","Purchaser Code",
              DATABASE::Campaign,"Campaign No.");

            IF xRec."Responsibility Center" <> "Responsibility Center" THEN BEGIN
              RecreatePurchLines(FIELDCAPTION("Responsibility Center"));
              "Assigned User ID" := '';
            END;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..21
              DATABASE::Campaign,"Campaign No.",
              DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
              DATABASE::Location,"Location Code",      // 10.03.2015 EDMS P21
              DATABASE::"Deal Type","Deal Type Code"  //12.06.2015 EB.P30 #042
              );
            {
            #24..27
            }

            IF UserSetupMgt.DefaultResponsibility THEN
              IF xRec."Responsibility Center" <> "Responsibility Center" THEN BEGIN
                RecreatePurchLines(FIELDCAPTION("Responsibility Center"));
                "Assigned User ID" := '';
              END
            ELSE
              IF xRec."Accountability Center" <> "Accountability Center" THEN BEGIN
                RecreatePurchLines(FIELDCAPTION("Accountability Center"));
                "Assigned User ID" := '';
              END
            */
        //end;


        //Unsupported feature: Code Modification on ""Assigned User ID"(Field 9000).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF NOT UserSetupMgt.CheckRespCenter2(1,"Responsibility Center","Assigned User ID") THEN
              ERROR(
                Text049,"Assigned User ID",
                RespCenter.TABLECAPTION,UserSetupMgt.GetPurchasesFilter2("Assigned User ID"));
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            {IF NOT UserSetupMgt.CheckRespCenter2(1,"Responsibility Center","Assigned User ID") THEN
            #2..4
            }

            IF UserSetupMgt.DefaultResponsibility THEN
              IF NOT UserSetupMgt.CheckRespCenter2(1,"Responsibility Center","Assigned User ID") THEN
                ERROR(
                  Text049,"Assigned User ID",
                  RespCenter.TABLECAPTION,UserSetupMgt.GetPurchasesFilter2("Assigned User ID"))
            ELSE
              IF NOT UserSetupMgt.CheckRespCenter2(1,"Accountability Center","Assigned User ID") THEN
                ERROR(
                  Text049,"Assigned User ID",
                  AccCenter.TABLECAPTION,UserSetupMgt.GetPurchasesFilter2("Assigned User ID"));
            */
        //end;
        field(50000;"Pragyapan Patra No.";Code[20])
        {
        }
        field(50001;"Import Invoice No.";Code[20])
        {

            trigger OnLookup()
            var
                PstdPurchInv: Page "146";
                                  PurchInvHeader: Record "122";
            begin
                CLEAR(PstdPurchInv);
                PstdPurchInv.SETTABLEVIEW(PurchInvHeader);
                PstdPurchInv.LOOKUPMODE(TRUE);
                IF PstdPurchInv.RUNMODAL = ACTION::LookupOK THEN
                 BEGIN
                  PstdPurchInv.GETRECORD(PurchInvHeader);
                END;
                "Import Invoice No." := PurchInvHeader."Vendor Invoice No.";
            end;
        }
        field(50002;"Battery Job No.";Code[20])
        {
        }
        field(50003;Remarks;Text[250])
        {
        }
        field(50005;Type;Option)
        {
            Description = 'Sandeep for procurement';
            OptionMembers = " ",Memo;
        }
        field(50006;"Memo No";Code[20])
        {
            Description = 'Aakrista for Procurement';
        }
        field(50007;"Posted Memo";Boolean)
        {
            Description = 'Aakrista for Procurement';
        }
        field(59010;"Total TDS Amount";Decimal)
        {
            CalcFormula = Sum("Purchase Line"."TDS Amount" WHERE (Document Type=FIELD(Document Type),
                                                                  Document No.=FIELD(No.)));
            FieldClass = FlowField;
        }
        field(70000;"Supplier Code";Code[10])
        {
            Description = 'QR19.00';
        }
        field(70001;"Lot No. Prefix";Code[20])
        {
            Description = 'QR19.00';
        }
        field(70071;"Procument Memo No.";Code[20])
        {
            Description = 'Procument Memo';
            TableRelation = "Procurement Memo" WHERE (Posted=CONST(Yes));
        }
        field(25006000;"Document Profile";Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = " ","Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006001;"Deal Type Code";Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";

            trigger OnValidate()
            var
                tcDMS001: Label 'Do you want to change lines too?';
                recPurchLine: Record "39";
            begin
                //12.06.2015 EB.P30 #042 >>
                TESTFIELD(Status,Status::Open);

                recPurchLine.RESET;
                recPurchLine.SETRANGE("Document Type","Document Type");
                recPurchLine.SETRANGE("Document No.","No.");
                IF recPurchLine.FINDSET(TRUE,FALSE) THEN
                 IF CONFIRM(tcDMS001) THEN
                  REPEAT
                   recPurchLine.VALIDATE("Deal Type Code","Deal Type Code");
                   recPurchLine.MODIFY;
                  UNTIL recPurchLine.NEXT = 0;

                CreateDim(
                  DATABASE::Vendor,"Pay-to Vendor No.",
                  DATABASE::"Salesperson/Purchaser","Purchaser Code",
                  DATABASE::Campaign,"Campaign No.",
                  DATABASE::"Responsibility Center","Responsibility Center",
                  DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
                  DATABASE::Location,"Location Code",      // 10.03.2015 EDMS P21
                  DATABASE::"Deal Type","Deal Type Code"   //12.06.2015 EB.P30 #042
                  );
                //12.06.2015 EB.P30 #042 <<
            end;
        }
        field(25006020;"Auto Created Doc";Boolean)
        {
            Caption = 'Auto Created Document';
        }
        field(25006170;"Vehicle Registration No.";Code[30])
        {
            Caption = 'Vehicle Registration No.';
            Editable = false;

            trigger OnLookup()
            begin
                OnLookupVehicleRegistrationNo;
            end;

            trigger OnValidate()
            var
                Vehicle: Record "25006005";
            begin
                IF "Vehicle Registration No." = '' THEN BEGIN
                  VALIDATE("Vehicle Serial No.",'');
                  EXIT;
                END;

                Vehicle.RESET;
                Vehicle.SETCURRENTKEY("Registration No.");
                Vehicle.SETRANGE("Registration No.","Vehicle Registration No.");
                IF Vehicle.FINDFIRST THEN BEGIN
                  IF "Vehicle Serial No." <> Vehicle."Serial No." THEN
                    VALIDATE("Vehicle Serial No.",Vehicle."Serial No.")
                END ELSE
                  MESSAGE(STRSUBSTNO(Text100, "Vehicle Registration No."), '');
            end;
        }
        field(25006378;"Vehicle Serial No.";Code[20])
        {
            Caption = 'Vehicle Serial No.';
            Description = 'Not for Vehicle Trade';

            trigger OnValidate()
            var
                Vehicle: Record "25006005";
            begin
                IF "Vehicle Serial No." = '' THEN BEGIN
                  "Vehicle Registration No." := '';
                END ELSE BEGIN
                  IF Vehicle.GET("Vehicle Serial No.") THEN
                    "Vehicle Registration No." := Vehicle."Registration No.";
                END;

                // 26.03.2014 Elva Baltic P18 #F011 #MMG7.00 >>
                CreateDim(
                  DATABASE::Vendor,"Pay-to Vendor No.",
                  DATABASE::"Salesperson/Purchaser","Purchaser Code",
                  DATABASE::Campaign,"Campaign No.",
                  DATABASE::"Responsibility Center","Responsibility Center",
                  DATABASE::Vehicle,"Vehicle Serial No.", //25.10.2013 EDMS P8
                  DATABASE::Location,"Location Code",      // 10.03.2015 EDMS P21
                  DATABASE::"Deal Type","Deal Type Code"  //12.06.2015 EB.P30 #042
                  );
                // 26.03.2014 Elva Baltic P18 #F011 #MMG7.00 <<
            end;
        }
        field(25006379;"Vehicle Accounting Cycle No.";Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Description = 'Only For Service or Spare Parts Trade';
            Editable = true;
            TableRelation = "Vehicle Accounting Cycle".No.;
        }
        field(25006700;"Ordering Price Type Code";Code[20])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";
        }
        field(33019810;"Shipping Agent Code";Code[10])
        {
            TableRelation = "Shipping Agent";
        }
        field(33019831;"Order Type";Option)
        {
            OptionCaption = ' ,Local,VOR,Import';
            OptionMembers = " ","Local",VOR,Import;
        }
        field(33019869;"Import Purch. Order";Boolean)
        {

            trigger OnValidate()
            begin
                InitRecord2;
            end;
        }
        field(33019870;"Import Purch. Invoice";Boolean)
        {
        }
        field(33019871;"Import Purch. Cr. Memo";Boolean)
        {
        }
        field(33019872;"Import Purch. Return Order";Boolean)
        {
        }
        field(33019961;"Accountability Center";Code[10])
        {
            Editable = true;
            TableRelation = "Accountability Center";

            trigger OnValidate()
            begin
                TESTFIELD(Status,Status::Open);
                IF NOT UserSetupMgt.CheckRespCenter(1,"Accountability Center") THEN
                  ERROR(
                    Text028,
                    AccCenter.TABLECAPTION,UserSetupMgt.GetPurchasesFilter);

                "Location Code" := UserSetupMgt.GetLocation(1,'',"Accountability Center");
                IF "Location Code" = '' THEN BEGIN
                  IF InvtSetup.GET THEN
                    "Inbound Whse. Handling Time" := InvtSetup."Inbound Whse. Handling Time";
                END ELSE BEGIN
                  IF Location.GET("Location Code") THEN;
                  "Inbound Whse. Handling Time" := Location."Inbound Whse. Handling Time";
                END;

                UpdateShipToAddress;

                IF xRec."Accountability Center" <> "Accountability Center" THEN BEGIN
                  RecreatePurchLines(FIELDCAPTION("Accountability Center"));
                  "Assigned User ID" := '';
                END;
            end;
        }
        field(33019962;"TDS Posting Group";Code[20])
        {
            TableRelation = "TDS Posting Group";
        }
        field(33020011;"Sys. LC No.";Code[20])
        {
            Caption = 'LC No.';
            TableRelation = "LC Details".No. WHERE (Transaction Type=CONST(Purchase),
                                                    Closed=CONST(No),
                                                    Released=CONST(Yes));

            trigger OnValidate()
            var
                LCDetail: Record "33020012";
                LCAmendDetail: Record "33020013";
                Text33020011: Label 'LC has amendments and amendment is not released.';
                Text33020012: Label 'LC has amendments and  amendment is closed.';
                Text33020013: Label 'LC Details is not released.';
                Text33020014: Label 'LC Details is closed.';
            begin
                //Code to check for LC Amendment and insert Bank LC No. and LC Amend No. (LC Version No.) if LC is amended atleast once.
                LCAmendDetail.RESET;
                LCAmendDetail.SETRANGE("No.","Sys. LC No.");
                IF LCAmendDetail.FIND('+') THEN BEGIN
                  IF NOT LCAmendDetail.Closed THEN BEGIN
                    IF LCAmendDetail.Released THEN BEGIN
                      "Bank LC No." := LCAmendDetail."Bank Amended No.";
                      "LC Amend No." := LCAmendDetail."Version No.";
                      MODIFY;
                    END ELSE
                      ERROR(Text33020011);
                  END ELSE
                    ERROR(Text33020012);
                END ELSE BEGIN
                  LCDetail.RESET;
                  LCDetail.SETRANGE("No.","Sys. LC No.");
                  IF LCDetail.FIND('-') THEN BEGIN
                    IF NOT LCDetail.Closed THEN BEGIN
                      IF LCDetail.Released THEN BEGIN
                        "Bank LC No." := LCDetail."LC\DO No.";
                        MODIFY;
                      END ELSE
                        ERROR(Text33020013);
                    END ELSE
                      ERROR(Text33020014);
                  END;
                END;
            end;
        }
        field(33020012;"Bank LC No.";Code[20])
        {
        }
        field(33020013;"LC Amend No.";Code[20])
        {
            Caption = 'Amendment No.';
            TableRelation = "LC Amend. Details"."Version No." WHERE (No.=FIELD(Sys. LC No.));
        }
        field(33020235;"Service Order No.";Code[20])
        {
            Description = 'Used for External Service Order';
            TableRelation = IF (Document Profile=CONST(Service)) "Service Header EDMS".No. WHERE (Responsibility Center=FIELD(Responsibility Center));

            trigger OnValidate()
            begin
                IF "Document Type" = "Document Type"::Order THEN BEGIN
                  ServiceLine.RESET;
                  ServiceLine.SETCURRENTKEY("Document Type","Document No.");
                  ServiceLine.SETRANGE("Document Type",ServiceLine."Document Type"::Order);
                  ServiceLine.SETRANGE("Document No.","Service Order No.");
                  ServiceLine.SETRANGE(Type,ServiceLine.Type::"External Service");
                  ServiceLine.SETRANGE("External Service Purchased",FALSE);
                  ServiceLine.SETRANGE("Ext-Serv. PO Created",FALSE);
                  IF ServiceLine.FINDSET THEN BEGIN
                      LastUsedLineNo := 0;
                      REPEAT
                        ExternalService.RESET;
                        ExternalService.SETRANGE("No.",ServiceLine."No.");
                        IF ExternalService.FINDFIRST THEN BEGIN
                          IF "Buy-from Vendor No." = ExternalService."Vendor No." THEN BEGIN
                            CLEAR(PurchLineFromService);
                            PurchLineFromService.INIT;
                            PurchLineFromService."Line No." := LastUsedLineNo + 10000; //Modified 7.29.2012
                            PurchLineFromService."Document Type" := "Document Type";
                            PurchLineFromService.VALIDATE("Document No.","No.");
                            PurchLineFromService.VALIDATE(Type,PurchLineFromService.Type::"External Service");
                            PurchLineFromService.VALIDATE("No.",ServiceLine."No.");
                            PurchLineFromService.Description := ServiceLine.Description;
                            PurchLineFromService."Description 2" := ServiceLine."Description 2";
                            PurchLineFromService.VALIDATE(Quantity,ServiceLine.Quantity);
                            PurchLineFromService."External Serv. Tracking No." := ServiceLine."External Serv. Tracking No.";
                            PurchLineFromService."Document Profile" := PurchLineFromService."Document Profile"::Service;
                            PurchLineFromService."Service Order No." := ServiceLine."Document No.";
                            PurchLineFromService."Service Order Line No." := ServiceLine."Line No.";
                            PurchLineFromService.INSERT(TRUE);
                            LastUsedLineNo := LastUsedLineNo + 10000;
                          END;
                        END;
                      ServiceLine."Ext-Serv. PO Created" := TRUE;
                      UNTIL ServiceLine.NEXT=0;
                  END;
                END;
            end;
        }
        field(33020237;"Veh. Accessories Document";Boolean)
        {
            Description = 'Used for Vehicle Accessories';
            Editable = false;
        }
        field(33020238;"Veh. Accesories Memo No.";Code[20])
        {
            Description = 'Used for Vehicle Accessories';
            Editable = false;
            TableRelation = "Vehicle Accessories Header";
        }
        field(33020239;"Accessories Total Amount";Decimal)
        {
            CalcFormula = Sum("Vehicle Accessories Line"."Line Amount" WHERE (Document No.=FIELD(Veh. Accesories Memo No.)));
            Description = 'Used for Vehicle Accessories';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33020240;"Purch. VAT No.";Code[20])
        {
            TableRelation = "Exempt Purchase Nos.";
        }
        field(33020601;"Approved User ID";Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(33020602;Narration;Text[250])
        {
        }
        field(33020603;"Total CBM";Decimal)
        {
            CalcFormula = Sum("Purchase Line".CBM WHERE (Document No.=FIELD(No.)));
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(Key1;"Document Profile")
        {
        }
    }


    //Unsupported feature: Code Insertion (VariableCollection) on "OnDelete".

    //trigger (Variable: ServiceLine)()
    //Parameters and return type have not been exported.
    //begin
        /*
        */
    //end;


    //Unsupported feature: Code Modification on "OnDelete".

    //trigger OnDelete()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF NOT UserSetupMgt.CheckRespCenter(1,"Responsibility Center") THEN
          ERROR(
            Text023,
            RespCenter.TABLECAPTION,UserSetupMgt.GetPurchasesFilter);

        PostPurchDelete.DeleteHeader(
          Rec,PurchRcptHeader,PurchInvHeader,PurchCrMemoHeader,
        #8..38
           (PurchCrMemoHeaderPrepmt."No." <> '')
        THEN
          MESSAGE(PostedDocsToPrintCreatedMsg);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        IF UserSetupMgt.DefaultResponsibility THEN
          IF NOT UserSetupMgt.CheckRespCenter(1,"Responsibility Center") THEN
            ERROR(
              Text023,
              RespCenter.TABLECAPTION,UserSetupMgt.GetPurchasesFilter)
        ELSE
          IF NOT UserSetupMgt.CheckRespCenter(1,"Accountability Center") THEN
            ERROR(
              Text023,
              RespCenter.TABLECAPTION,UserSetupMgt.GetPurchasesFilter);
        #5..41
        */
    //end;


    //Unsupported feature: Code Modification on "OnInsert".

    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF NOT SkipInitialization THEN
          InitInsert;

        IF GETFILTER("Buy-from Vendor No.") <> '' THEN
          IF GETRANGEMIN("Buy-from Vendor No.") = GETRANGEMAX("Buy-from Vendor No.") THEN
            VALIDATE("Buy-from Vendor No.",GETRANGEMIN("Buy-from Vendor No."));
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        IF "Posting No." <> '' THEN
          ERROR('You cannot delete document if posting no. is reserved');


        #1..6

        IF CheckDefaultVendor THEN
          GetDefaultVendor;
        */
    //end;


    //Unsupported feature: Code Modification on "InitInsert(PROCEDURE 41)".

    //procedure InitInsert();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF "No." = '' THEN BEGIN
          TestNoSeries;
          NoSeries.GET(GetNoSeriesCode);
          IF (NOT NoSeries."Default Nos.") AND SelectNoSeriesAllowed AND NoSeriesMgt.IsSeriesSelected THEN
            NoSeriesMgt.SetSeries("No.")
          ELSE
            NoSeriesMgt.InitSeries(NoSeries.Code,xRec."No. Series","Posting Date","No.","No. Series");
        END;

        InitRecord;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        IF "No." = '' THEN BEGIN
          TestNoSeries;
          NoSeries.GET(GetNoSeriesCode2);
        #4..9
        InitRecord2;
        "Assigned User ID" := USERID;
        */
    //end;


    //Unsupported feature: Code Modification on "InitRecord(PROCEDURE 10)".

    //procedure InitRecord();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        PurchSetup.GET;

        CASE "Document Type" OF
        #4..63
          Correction := GLSetup."Mark Cr. Memos as Corrections";
        END;

        "Posting Description" := FORMAT("Document Type") + ' ' + "No.";

        IF InvtSetup.GET THEN
          "Inbound Whse. Handling Time" := InvtSetup."Inbound Whse. Handling Time";

        "Responsibility Center" := UserSetupMgt.GetRespCenter(1,"Responsibility Center");
        "Doc. No. Occurrence" := ArchiveManagement.GetNextOccurrenceNo(DATABASE::"Purchase Header","Document Type","No.");
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..66
        //"Posting Description" := FORMAT("Document Type")  //RL 6/27/19
        #68..71
        //"Responsibility Center" := UserSetupMgt.GetRespCenter(1,"Responsibility Center");

        IF UserSetupMgt.DefaultResponsibility THEN
          "Responsibility Center" := UserSetupMgt.GetRespCenter(1,"Responsibility Center")
        ELSE
          "Accountability Center" := UserSetupMgt.GetRespCenter(1,"Accountability Center");
        "Doc. No. Occurrence" := ArchiveManagement.GetNextOccurrenceNo(DATABASE::"Purchase Header","Document Type","No.");
        */
    //end;


    //Unsupported feature: Code Modification on "AssistEdit(PROCEDURE 2)".

    //procedure AssistEdit();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        PurchSetup.GET;
        TestNoSeries;
        IF NoSeriesMgt.SelectSeries(GetNoSeriesCode,OldPurchHeader."No. Series","No. Series") THEN BEGIN
          PurchSetup.GET;
          TestNoSeries;
          NoSeriesMgt.SetSeries("No.");
          EXIT(TRUE);
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        PurchSetup.GET;
        TestNoSeries;
        IF NoSeriesMgt.SelectSeries(GetNoSeriesCode2,OldPurchHeader."No. Series","No. Series") THEN BEGIN
        #4..8
        */
    //end;


    //Unsupported feature: Code Modification on "RecreatePurchLines(PROCEDURE 4)".

    //procedure RecreatePurchLines();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF PurchLinesExist THEN BEGIN
          IF HideValidationDialog THEN
            Confirmed := TRUE
        #4..65
                  PurchLine.INIT;
                  PurchLine."Line No." := PurchLine."Line No." + 10000;
                  PurchLine.VALIDATE(Type,TempPurchLine.Type);
                  IF TempPurchLine."No." = '' THEN BEGIN
                    PurchLine.VALIDATE(Description,TempPurchLine.Description);
                    PurchLine.VALIDATE("Description 2",TempPurchLine."Description 2");
                  END ELSE BEGIN
                    PurchLine.VALIDATE("No.",TempPurchLine."No.");
                    IF PurchLine.Type <> PurchLine.Type::" " THEN
                      CASE TRUE OF
                        TempPurchLine."Drop Shipment":
        #77..140
            ERROR(
              Text018,ChangedFieldName);
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..68

                  //EDMS1.0.00 >>
                   PurchLine."Document Profile" := TempPurchLine."Document Profile";
                   PurchLine.VALIDATE(Type,TempPurchLine.Type);
                   PurchLine."Line Type" := TempPurchLine."Line Type";
                  //EDMS1.0.00 <<

        #69..72
                    //EDMS1.0.00 >>
                     PurchLine.VALIDATE("Make Code",TempPurchLine."Make Code");
                     PurchLine.VALIDATE("Model Code",TempPurchLine."Model Code");
                     PurchLine.VALIDATE("Model Version No.",TempPurchLine."Model Version No.");
                    //EDMS1.0.00 <<

                    PurchLine.VALIDATE("No.",TempPurchLine."No.");

                    PurchLine.VALIDATE("Location Code","Location Code");

                    //SM  06-09-2013 not to delete customer no. while recreating purchase lines
                    IF PurchLine."Line Type" = PurchLine."Line Type" :: Vehicle THEN
                        PurchLine.VALIDATE("Customer No.",TempPurchLine."Customer No.");
                    //SM  06-09-2013 not to delete customer no. while recreating purchase lines

                    //EDMS1.0.00 >>
                      PurchLine.VALIDATE("Vehicle Serial No.",TempPurchLine."Vehicle Serial No.");
                      PurchLine.VALIDATE("Vehicle Accounting Cycle No.",TempPurchLine."Vehicle Accounting Cycle No.");
                    //EDMS1.0.00 <<

        #74..143
        */
    //end;

    //Unsupported feature: Parameter Insertion (Parameter: Type5) (ParameterCollection) on "CreateDim(PROCEDURE 16)".


    //Unsupported feature: Parameter Insertion (Parameter: No5) (ParameterCollection) on "CreateDim(PROCEDURE 16)".


    //Unsupported feature: Parameter Insertion (Parameter: Type6) (ParameterCollection) on "CreateDim(PROCEDURE 16)".


    //Unsupported feature: Parameter Insertion (Parameter: No6) (ParameterCollection) on "CreateDim(PROCEDURE 16)".


    //Unsupported feature: Parameter Insertion (Parameter: Type7) (ParameterCollection) on "CreateDim(PROCEDURE 16)".


    //Unsupported feature: Parameter Insertion (Parameter: No7) (ParameterCollection) on "CreateDim(PROCEDURE 16)".



    //Unsupported feature: Code Modification on "CreateDim(PROCEDURE 16)".

    //procedure CreateDim();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        SourceCodeSetup.GET;
        TableID[1] := Type1;
        No[1] := No1;
        #4..6
        No[3] := No3;
        TableID[4] := Type4;
        No[4] := No4;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        OldDimSetID := "Dimension Set ID";
        #13..16
          MODIFY;
          UpdateAllLineDim("Dimension Set ID",OldDimSetID);
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        // Sipradi-YS GEN6.1.0 - 38.1 * Following Standard Code is commented to Override Retrieving of Dimension
        {
        #1..9
        TableID[5] := Type5;  //25.10.2013 EDMS P8
        No[5] := No5;
        // 10.03.2015 EDMS P21 >>
        TableID[6] := Type6;
        No[6] := No6;
        // 10.03.2015 EDMS P21 <<
        // 12.06.2015 EB.P30 #T042 >>
        TableID[7] := Type7;
        No[7] := No7;
        // 12.06.2015 EB.P30 #T042 <<

        #10..19
        }
        */
    //end;


    //Unsupported feature: Code Modification on "SetSecurityFilterOnRespCenter(PROCEDURE 43)".

    //procedure SetSecurityFilterOnRespCenter();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        IF UserSetupMgt.GetPurchasesFilter <> '' THEN BEGIN
          FILTERGROUP(2);
          SETRANGE("Responsibility Center",UserSetupMgt.GetPurchasesFilter);
          FILTERGROUP(0);
        END;

        SETRANGE("Date Filter",0D,WORKDATE - 1);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        {
        #1..5
        }
        SETRANGE("Date Filter",0D,WORKDATE - 1);
        */
    //end;


    //Unsupported feature: Code Modification on "CreateDimSetForPrepmtAccDefaultDim(PROCEDURE 44)".

    //procedure CreateDimSetForPrepmtAccDefaultDim();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        PurchaseLine.SETRANGE("Document Type","Document Type");
        PurchaseLine.SETRANGE("Document No.","No.");
        PurchaseLine.SETFILTER("Prepmt. Amt. Inv.",'<>%1',0);
        #4..8
        TempPurchaseLine.MARKEDONLY(FALSE);
        IF TempPurchaseLine.FINDSET THEN
          REPEAT
            PurchaseLine.CreateDim(DATABASE::"G/L Account",TempPurchaseLine."No.",
              DATABASE::Job,TempPurchaseLine."Job No.",
              DATABASE::"Responsibility Center",TempPurchaseLine."Responsibility Center",
              DATABASE::"Work Center",TempPurchaseLine."Work Center No.");
          UNTIL TempPurchaseLine.NEXT = 0;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..11
            //16.04.2015 EB.P7 #Merge >>
        #12..14
              DATABASE::"Work Center",TempPurchaseLine."Work Center No.",
              0,'',
              0,'',
              0,'',
              0,''
            );
            //16.04.2015 EB.P7 #Merge <<
          UNTIL TempPurchaseLine.NEXT = 0;
        */
    //end;


    //Unsupported feature: Code Modification on "GetCardpageID(PROCEDURE 58)".

    //procedure GetCardpageID();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        CASE "Document Type" OF
          "Document Type"::Quote:
            EXIT(PAGE::"Purchase Quote");
          "Document Type"::Order:
            EXIT(PAGE::"Purchase Order");
          "Document Type"::Invoice:
            EXIT(PAGE::"Purchase Invoice");
          "Document Type"::"Credit Memo":
            EXIT(PAGE::"Purchase Credit Memo");
          "Document Type"::"Blanket Order":
            EXIT(PAGE::"Blanket Purchase Order");
          "Document Type"::"Return Order":
            EXIT(PAGE::"Purchase Return Order");
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..8
            EXIT(PAGE::"Debit Memo");
        #10..14
        */
    //end;


    //Unsupported feature: Code Modification on "InitFromVendor(PROCEDURE 68)".

    //procedure InitFromVendor();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        PurchLine.SETRANGE("Document Type","Document Type");
        PurchLine.SETRANGE("Document No.","No.");
        IF VendorNo = '' THEN BEGIN
          IF NOT PurchLine.ISEMPTY THEN
            ERROR(Text005,VendorCaption);
          INIT;
          PurchSetup.GET;
          "No. Series" := xRec."No. Series";
          InitRecord;
          InitNoSeries;
          EXIT(TRUE);
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..8
          InitRecord2;
        #10..12
        */
    //end;


    //Unsupported feature: Code Modification on "InitFromContact(PROCEDURE 69)".

    //procedure InitFromContact();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
        /*
        PurchLine.SETRANGE("Document Type","Document Type");
        PurchLine.SETRANGE("Document No.","No.");
        IF (ContactNo = '') AND (VendorNo = '') THEN BEGIN
          IF NOT PurchLine.ISEMPTY THEN
            ERROR(Text005,ContactCaption);
          INIT;
          PurchSetup.GET;
          "No. Series" := xRec."No. Series";
          InitRecord;
          InitNoSeries;
          EXIT(TRUE);
        END;
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        #1..8
          InitRecord2;
        #10..12
        */
    //end;

    procedure fSetUserDefaultValues()
    var
        recUserSetup: Record "91";
        recWorkPlace: Record "25006067";
        UserProfileMgt: Codeunit "25006002";
    begin
        recUserSetup.RESET;
         IF recUserSetup.GET(USERID) THEN
          BEGIN
           IF recUserSetup."Salespers./Purch. Code" <> '' THEN
            VALIDATE("Purchaser Code",recUserSetup."Salespers./Purch. Code");
          END;
         IF UserProfileMgt.CurrProfileID <> '' THEN
          BEGIN
           IF recWorkPlace.GET(UserProfileMgt.CurrProfileID) THEN
            BEGIN
             IF recWorkPlace."Default Location Code" <> '' THEN
              VALIDATE("Location Code",recWorkPlace."Default Location Code");
             IF "Deal Type Code" = '' THEN
               IF recWorkPlace."Default Deal Type Code" <> '' THEN
                 VALIDATE("Deal Type Code", recWorkPlace."Default Deal Type Code");
            END;
          END;
    end;

    procedure GetDefaultVendor()
    var
        recWorkPlace: Record "25006067";
        UserProfileMgt: Codeunit "25006002";
    begin
        IF UserProfileMgt.CurrProfileID <> '' THEN BEGIN
          IF recWorkPlace.GET(UserProfileMgt.CurrProfileID) THEN BEGIN
            IF "Buy-from Vendor No." = '' THEN BEGIN
              IF recWorkPlace."Default Vendor No." <> '' THEN
                VALIDATE("Buy-from Vendor No.",recWorkPlace."Default Vendor No.");
            END;
          END;
        END;
    end;

    procedure SetDefaultVendor()
    begin
        CheckDefaultVendor := TRUE;
    end;

    procedure OnLookupVehicleRegistrationNo()
    var
        LookUpMgt: Codeunit "25006003";
        Vehicle: Record "25006005";
    begin
        IF "Vehicle Registration No." <> '' THEN BEGIN
          Vehicle.RESET;
          Vehicle.SETCURRENTKEY("Registration No.");
          Vehicle.SETRANGE("Registration No.","Vehicle Registration No.");
          IF Vehicle.FINDFIRST THEN;
          Vehicle.SETRANGE("Registration No.");
        END;

        IF LookUpMgt.LookUpVehicleAMT(Vehicle,"Vehicle Serial No.") THEN
         VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
    end;

    procedure GetPostingNoSeries()
    begin
        // Sipradi-YS GEN6.1.0 38.2 BEGIN >> Getting Posting No. Series based on user Branch,Cost Center and document type.
        /*VALIDATE("Posting No. Series",StplSysMgt.getPostingNoSeries(1,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code"));
        */IF "Posting No. Series" = '' THEN
          VALIDATE("Posting No. Series",GetPostingNoSeriesCode);

    end;

    procedure InitRecord2()
    begin
        PurchSetup.GET;
        CASE "Document Type" OF
          "Document Type"::Quote,"Document Type"::Order:
            BEGIN
              //Import Purchase Order No. Series >> AGILE SRT 01-Aug-16
              IF "Import Purch. Order" THEN BEGIN
                NoSeriesMgt.SetDefaultSeries("Posting No. Series",
                                            StplSysMgt.getLocWiseImpOrdNoSeries(DocumentProfile::Purchase,DocumentType::"Posted Invoice"));
                NoSeriesMgt.SetDefaultSeries("Receiving No. Series",
                StplSysMgt.getLocWiseImpOrdNoSeries(DocumentProfile::Purchase,DocumentType::"Posted Receipt"));
              END
              //Import Purchase Order No. Series << AGILE SRT 01-Aug-16
              ELSE BEGIN
                NoSeriesMgt.SetDefaultSeries("Posting No. Series",
                                            StplSysMgt.getLocWiseNoSeries(DocumentProfile::Purchase,DocumentType::"Posted Invoice"));
                NoSeriesMgt.SetDefaultSeries("Receiving No. Series",
                StplSysMgt.getLocWiseNoSeries(DocumentProfile::Purchase,DocumentType::"Posted Receipt"));
              END;
              IF "Document Type" = "Document Type"::Order THEN BEGIN
                NoSeriesMgt.SetDefaultSeries("Prepayment No. Series",
                                              StplSysMgt.getLocWiseNoSeries(DocumentProfile::Purchase,
                                              DocumentType::"Posted Prepmt. Inv."));
                NoSeriesMgt.SetDefaultSeries("Prepmt. Cr. Memo No. Series",
                                              StplSysMgt.getLocWiseNoSeries(DocumentProfile::Purchase,
                                              DocumentType::"Posted Prepmt. Cr. Memo"));
              END;

            END;
          "Document Type"::Invoice:
            BEGIN
            //Import Purchase Order No. Series >> AGILE SRT 01-Aug-16
            IF "Import Purch. Order" THEN BEGIN
              IF ("No. Series" <> '') AND
                 (StplSysMgt.getLocWiseImpOrdNoSeries(DocumentProfile::Purchase,DocumentType::Invoice) =
                 StplSysMgt.getLocWiseImpOrdNoSeries(DocumentProfile::Purchase,DocumentType::"Posted Invoice"))
              THEN
                "Posting No. Series" := "No. Series"
              ELSE
                NoSeriesMgt.SetDefaultSeries("Posting No. Series",
                                              StplSysMgt.getLocWiseImpOrdNoSeries(DocumentProfile::Purchase,DocumentType::"Posted Invoice")
        );
              IF PurchSetup."Receipt on Invoice" THEN
                NoSeriesMgt.SetDefaultSeries("Receiving No. Series",
                                              StplSysMgt.getLocWiseImpOrdNoSeries(DocumentProfile::Purchase,DocumentType::"Posted Receipt")
        );
              END
              //Import Purchase Order No. Series << AGILE SRT 01-Aug-16
              ELSE BEGIN
              IF ("No. Series" <> '') AND
                 (StplSysMgt.getLocWiseNoSeries(DocumentProfile::Purchase,DocumentType::Invoice) =
                 StplSysMgt.getLocWiseNoSeries(DocumentProfile::Purchase,DocumentType::"Posted Invoice"))
              THEN
                "Posting No. Series" := "No. Series"
              ELSE
                NoSeriesMgt.SetDefaultSeries("Posting No. Series",
                                              StplSysMgt.getLocWiseNoSeries(DocumentProfile::Purchase,DocumentType::"Posted Invoice")
        );
              IF PurchSetup."Receipt on Invoice" THEN
                NoSeriesMgt.SetDefaultSeries("Receiving No. Series",
                                              StplSysMgt.getLocWiseNoSeries(DocumentProfile::Purchase,DocumentType::"Posted Receipt")
        );    END;
            END;
          "Document Type"::"Return Order":
            BEGIN
            //Import Purchase Order No. Series >> AGILE SRT 01-Aug-16
            IF "Import Purch. Order" THEN BEGIN
              NoSeriesMgt.SetDefaultSeries("Posting No. Series",
                                          StplSysMgt.getLocWiseImpOrdNoSeries(DocumentProfile::Purchase,DocumentType::"Posted Credit Memo")
        );
              NoSeriesMgt.SetDefaultSeries("Return Shipment No. Series",
                                          StplSysMgt.getLocWiseImpOrdNoSeries(DocumentProfile::Purchase,
                                          DocumentType::"Posted Return Shipment"));
            END
            //Import Purchase Order No. Series << AGILE SRT 01-Aug-16
            ELSE BEGIN
              NoSeriesMgt.SetDefaultSeries("Posting No. Series",
                                          StplSysMgt.getLocWiseNoSeries(DocumentProfile::Purchase,DocumentType::"Posted Credit Memo")
        );
              NoSeriesMgt.SetDefaultSeries("Return Shipment No. Series",
                                          StplSysMgt.getLocWiseNoSeries(DocumentProfile::Purchase,
                                          DocumentType::"Posted Return Shipment"));
            END;
            END;
          "Document Type"::"Credit Memo":
            BEGIN
            //Import Purchase Order No. Series >> AGILE SRT 01-Aug-16
            IF "Import Purch. Order" THEN BEGIN
              IF ("No. Series" <> '') AND
                 (StplSysMgt.getLocWiseImpOrdNoSeries(DocumentProfile::Purchase,DocumentType::"Credit Memo") =
                 StplSysMgt.getLocWiseImpOrdNoSeries(DocumentProfile::Purchase,DocumentType::"Posted Credit Memo"))
              THEN
                "Posting No. Series" := "No. Series"
              ELSE
                NoSeriesMgt.SetDefaultSeries("Posting No. Series",
                                              StplSysMgt.getLocWiseImpOrdNoSeries(DocumentProfile::Purchase,
                                              DocumentType::"Posted Credit Memo"));
              IF PurchSetup."Return Shipment on Credit Memo" THEN
                NoSeriesMgt.SetDefaultSeries("Return Shipment No. Series",
                                              StplSysMgt.getLocWiseImpOrdNoSeries(DocumentProfile::Purchase,
                                              DocumentType::"Posted Return Shipment"));
            END
            //Import Purchase Order No. Series << AGILE SRT 01-Aug-16
            ELSE BEGIN
              IF ("No. Series" <> '') AND
                 (StplSysMgt.getLocWiseNoSeries(DocumentProfile::Purchase,DocumentType::"Credit Memo") =
                 StplSysMgt.getLocWiseNoSeries(DocumentProfile::Purchase,DocumentType::"Posted Credit Memo"))
              THEN
                "Posting No. Series" := "No. Series"
              ELSE
                NoSeriesMgt.SetDefaultSeries("Posting No. Series",
                                              StplSysMgt.getLocWiseNoSeries(DocumentProfile::Purchase,
                                              DocumentType::"Posted Credit Memo"));
              IF PurchSetup."Return Shipment on Credit Memo" THEN
                NoSeriesMgt.SetDefaultSeries("Return Shipment No. Series",
                                              StplSysMgt.getLocWiseNoSeries(DocumentProfile::Purchase,
                                              DocumentType::"Posted Return Shipment"));
            END;
            END;
        END;

        IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice,"Document Type"::"Return Order"] THEN
          "Order Date" := WORKDATE;

        IF "Document Type" = "Document Type"::Invoice THEN
          "Expected Receipt Date" := WORKDATE;

        IF NOT ("Document Type" IN ["Document Type"::"Blanket Order","Document Type"::Quote]) AND
           ("Posting Date" = 0D)
        THEN
          "Posting Date" := WORKDATE;

        IF PurchSetup."Default Posting Date" = PurchSetup."Default Posting Date"::"No Date" THEN
          "Posting Date" :=0D;

        "Document Date" := WORKDATE;

        VALIDATE("Sell-to Customer No.",'');

        IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
          GLSetup.GET;
          Correction := GLSetup."Mark Cr. Memos as Corrections";
        END;

        //"Posting Description" := FORMAT("Document Type")  //RL 6/27/019

        IF InvtSetup.GET THEN
          "Inbound Whse. Handling Time" := InvtSetup."Inbound Whse. Handling Time";

        IF UserSetupMgt.DefaultResponsibility THEN
          "Responsibility Center" := UserSetupMgt.GetRespCenter(1,"Responsibility Center")
        ELSE
          "Accountability Center" := UserSetupMgt.GetRespCenter(1,"Accountability Center");
    end;

    local procedure GetNoSeriesCode2(): Code[10]
    begin
        CASE "Document Type" OF
          "Document Type"::Quote:
            EXIT(StplSysMgt.getLocWiseNoSeries(DocumentProfile::Purchase,DocumentType::Quote));
          "Document Type"::Order:
            BEGIN
            IF "Import Purch. Order" THEN
              EXIT(StplSysMgt.getLocWiseImpOrdNoSeries(DocumentProfile::Purchase,DocumentType::Order))
            ELSE
              EXIT(StplSysMgt.getLocWiseNoSeries(DocumentProfile::Purchase,DocumentType::Order));
            END;
          "Document Type"::Invoice:
            BEGIN
            IF "Import Purch. Order" THEN
              EXIT(StplSysMgt.getLocWiseImpOrdNoSeries(DocumentProfile::Purchase,DocumentType::Invoice))
            ELSE
              EXIT(StplSysMgt.getLocWiseNoSeries(DocumentProfile::Purchase,DocumentType::Invoice));
            END;
          "Document Type"::"Return Order":
            BEGIN
            IF "Import Purch. Order" THEN
              EXIT(StplSysMgt.getLocWiseImpOrdNoSeries(DocumentProfile::Purchase,DocumentType::"Return Order"))
            ELSE
              EXIT(StplSysMgt.getLocWiseNoSeries(DocumentProfile::Purchase,DocumentType::"Return Order"));
            END;
          "Document Type"::"Credit Memo":
           BEGIN
           IF "Import Purch. Order" THEN
            EXIT(StplSysMgt.getLocWiseImpOrdNoSeries(DocumentProfile::Purchase,DocumentType::"Credit Memo"))
           ELSE
            EXIT(StplSysMgt.getLocWiseNoSeries(DocumentProfile::Purchase,DocumentType::"Credit Memo"));
           END;
          "Document Type"::"Blanket Order":
            EXIT(StplSysMgt.getLocWiseNoSeries(DocumentProfile::Purchase,DocumentType::"Blanket Order"));
        END;
    end;

    procedure CalculateTDS()
    var
        TDSPostingGroup: Record "33019849";
        PurchaseLine: Record "39";
        Currency: Record "4";
    begin
        // TDS2.00 >>

        Currency.InitRoundingPrecision;

        PurchaseLine.RESET;
        PurchaseLine.SETRANGE("Document Type","Document Type");
        PurchaseLine.SETRANGE("Document No.","No.");
        PurchaseLine.SETFILTER("TDS Group",'<>%1','');
        IF PurchaseLine.FINDFIRST THEN BEGIN
          REPEAT
            IF "Prices Including VAT" THEN
              PurchaseLine."TDS Base Amount" := (PurchaseLine."Direct Unit Cost" - (PurchaseLine."Direct Unit Cost" * PurchaseLine."VAT %" /
              100)) * PurchaseLine."Qty. to Invoice"
            ELSE
              PurchaseLine."TDS Base Amount" := PurchaseLine."Direct Unit Cost" * PurchaseLine."Qty. to Invoice";

            PurchaseLine."TDS Amount" := ROUND(PurchaseLine."TDS Base Amount" * PurchaseLine."TDS%" / 100,
                                         Currency."Amount Rounding Precision",Currency.VATRoundingDirection);
            PurchaseLine."TDS Type" := PurchaseLine."TDS Type"::"Purchase TDS";
            PurchaseLine.MODIFY;
          UNTIL PurchaseLine.NEXT = 0;
        END;
        // TDS2.00 <<
    end;

    var
        UserSetup: Record "91";

    var
        ServiceLine: Record "25006146";

    var
        CheckDefaultVendor: Boolean;
        cuSingleInstanceMgt: Codeunit "25006001";

    var
        tcDMS001: Label 'Update lines too?';

    var
        ErrVendNoIINPayer: Label 'Vendor %1 is not %2. You mustn''t enter %3! ';
        ErrIINJustAmSign: Label 'For credit memo IIN just. amount must be negative!';
        Text100: Label 'There is no vehicle with Registration No. %1';
        StplSysMgt: Codeunit "50000";
        DocumentProfile: Option Purchase,Sales,Service,Transfer;
        DocumentType: Option Quote,"Blanket Order","Order","Return Order",Invoice,"Posted Invoice","Credit Memo","Posted Credit Memo","Posted Shipment","Posted Receipt","Posted Prepmt. Inv.","Posted Prepmt. Cr. Memo","Posted Return Receipt","Posted Return Shipment";
        ServiceLine: Record "25006146";
        PurchLineFromService: Record "39";
        LastUsedLineNo: Integer;
        ExternalService: Record "25006133";
        AccCenter: Record "33019846";
        PurchaseLineExists: Label 'Delete all Purchase Lines before adding External Service.';
}

