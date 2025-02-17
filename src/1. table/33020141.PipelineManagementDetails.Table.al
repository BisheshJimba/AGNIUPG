table 33020141 "Pipeline Management Details"
{

    fields
    {
        field(1; "Prospect No."; Code[20])
        {
            Editable = false;
            TableRelation = Contact;
        }
        field(2; "Line No."; Integer)
        {
            Editable = false;
        }
        field(10; "Created Date"; Date)
        {
            Editable = false;
        }
        field(12; "Last Modified Date"; Date)
        {
            Editable = false;
        }
        field(15; "Pipeline Code"; Code[10])
        {
            Editable = false;
            TableRelation = "Pipeline Steps";
        }
        field(20; "Prospect Type"; Code[10])
        {
            TableRelation = "CRM Master Template".Code WHERE(Master Options=CONST(ProspectType),
                                                              Active=CONST(Yes),
                                                              Division Type=FIELD(Vehicle Division));
        }
        field(25;"Vehicle Division";Option)
        {
            Editable = false;
            OptionCaption = ' ,CVD,PCD';
            OptionMembers = " ",CVD,PCD;

            trigger OnValidate()
            begin
                // CNY.CRM >>
                IF "Vehicle Division" = "Vehicle Division" :: PCD THEN
                  "Make Code" := 'TATA PCD';
                IF "Vehicle Division" = "Vehicle Division" :: CVD THEN
                  "Make Code" := 'TATA CVD';
                // CNY.CRM <<
            end;
        }
        field(27;Purpose;Option)
        {
            Description = 'F001';
            NotBlank = true;
            OptionCaption = ' ,Personal,Commercial,Both,Official';
            OptionMembers = " ",Personal,Commercial,Both,Official;

            trigger OnValidate()
            begin
                // CNY.CRM >>

                IF UserSetup_G.GET(USERID) THEN BEGIN
                   IF SalesPerson_G.GET(UserSetup_G."Salespers./Purch. Code") THEN BEGIN
                    VALIDATE("Vehicle Division",SalesPerson_G."Vehicle Division");
                    VALIDATE("Salesperson Code",SalesPerson_G.Code);
                   END;
                END;

                // CNY.CRM <<
            end;
        }
        field(29;"Source of Inquiry";Code[150])
        {
            NotBlank = true;
            TableRelation = "CRM Master Template".Code WHERE (Master Options=CONST(MediaMotivator),
                                                              Active=CONST(Yes),
                                                              Division Type=FIELD(Vehicle Division));
        }
        field(30;"Sales Progress";Code[150])
        {
            TableRelation = "CRM Master Template".Code WHERE (Master Options=CONST(SalesProgress),
                                                              Active=CONST(Yes),
                                                              Division Type=FIELD(Vehicle Division));
        }
        field(31;"Sales Progress Details";Code[10])
        {
            TableRelation = "Sales Progress Details".Code WHERE (Sales Progress=FIELD(Sales Progress));
        }
        field(33;"Time Line for Purchase";Code[150])
        {
            Caption = 'Time Line for Purchase';
            TableRelation = "CRM Master Template".Code WHERE (Master Options=CONST(Time Line for Purchase),
                                                              Active=CONST(Yes),
                                                              Division Type=FIELD(Vehicle Division));
        }
        field(35;"Test Drive (Y/N)";Boolean)
        {
        }
        field(38;Red;Boolean)
        {
            Description = 'CNY.CRM For C2 Substages';
            Editable = false;
        }
        field(39;Yellow;Boolean)
        {
            Description = 'CNY.CRM For C2 Substages';
            Editable = false;
        }
        field(40;Green;Boolean)
        {
            Description = 'CNY.CRM For C2 Substages';
            Editable = false;
        }
        field(46;"Salesperson Code";Code[10])
        {
            TableRelation = Salesperson/Purchaser;

            trigger OnValidate()
            begin
                // CNY.CRM >>
                IF SalesPerson_G.GET("Salesperson Code") THEN BEGIN
                  "SP Description" := SalesPerson_G.Name;
                  "Global Dimension 1 Code" := SalesPerson_G."Global Dimension 1 Code";
                  "Global Dimension 2 Code" := SalesPerson_G."Global Dimension 2 Code";
                END;

                IF UserSetup_G.GET(USERID) THEN BEGIN
                  IF NOT UserSetup_G."Allow SP change in Contact" THEN
                    IF xRec."Salesperson Code" <> '' THEN
                      IF xRec."Salesperson Code" <> "Salesperson Code" THEN
                        ERROR('You are not authorized user to change the sales person');
                END;
                // CNY.CRM <<
            end;
        }
        field(47;"Make Code";Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(48;"Model Code";Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code WHERE (Make Code=FIELD(Make Code));
        }
        field(49;"Model Version No.";Code[20])
        {

            trigger OnLookup()
            begin
                // CNY.CRM >>
                ItemRec.RESET;
                ItemRec.SETRANGE("Item Type",ItemRec."Item Type" :: "Model Version");
                ItemRec.SETRANGE("Make Code","Make Code");
                ItemRec.SETRANGE("Model Code","Model Code");
                ItemRec.SETRANGE(Blocked,FALSE);
                IF PAGE.RUNMODAL(33020136,ItemRec) = ACTION :: LookupOK THEN
                  VALIDATE("Model Version No.",ItemRec."No.");
                // CNY.CRM <<
            end;

            trigger OnValidate()
            begin
                // CNY.CRM >>
                PipeLineDetails_G.RESET;
                PipeLineDetails_G.SETRANGE("Prospect No.","Prospect No.");
                PipeLineDetails_G.SETFILTER("Salesperson Code",'<>%1',"Salesperson Code");
                PipeLineDetails_G.SETRANGE("Model Version No.","Model Version No.");
                IF PipeLineDetails_G.FINDFIRST THEN
                  ERROR('This Prosect is already in pipeline with Sales officer %1 ',PipeLineDetails_G."SP Description");
                // CNY.CRM <<
                ItemRec.RESET;   //added by paras for hs code 7/23/2024
                ItemRec.SETRANGE("No.",Rec."Model Version No.");
                ItemRec.SETRANGE("Item Type",ItemRec."Item Type"::"Model Version");
                IF ItemRec.FINDFIRST THEN BEGIN
                  IF TariffNumberRec.GET(ItemRec."Tariff No.") THEN
                    Rec."HS Code" := TariffNumberRec."Show HS Code";
                  END;
            end;
        }
        field(50;"Sales Quote No.";Code[20])
        {
            FieldClass = Normal;
            TableRelation = "Sales Line"."Document No." WHERE (Document Type=CONST(Quote));
        }
        field(51;"Sales Order No.";Code[20])
        {
            FieldClass = Normal;
            TableRelation = "Sales Line"."Document No." WHERE (Document Type=CONST(Order));
        }
        field(52;"Sales Invoice No.";Code[20])
        {
            FieldClass = Normal;
            TableRelation = "Sales Invoice Line"."Document No.";
        }
        field(55;"SP Description";Text[50])
        {
            Editable = false;
        }
        field(60;"Pipeline Status";Option)
        {
            Editable = false;
            OptionCaption = 'Open,Closed,Lost,Returned,Returned but Considered';
            OptionMembers = Open,Closed,Lost,Returned,"Returned but Considered";
        }
        field(61;"Lost Reason Code";Text[250])
        {
            Description = 'For lost Prospect';

            trigger OnLookup()
            begin
                // CNY.CRM >>
                CRMMaster_G.RESET;
                CRMMaster_G.SETRANGE("Master Options",CRMMaster_G."Master Options" :: LostProspect);
                CRMMaster_G.SETRANGE(Active,TRUE);
                IF PAGE.RUNMODAL(33020195,CRMMaster_G) = ACTION :: LookupOK THEN BEGIN
                  "Lost Reason Code" := CRMMaster_G.Description;
                END;
                // CNY.CRM <<
            end;
        }
        field(63;Remarks;Text[250])
        {
            Description = 'For Other Status';
        }
        field(5051;"Company No.";Code[20])
        {
            Caption = 'Company No.';
            Editable = false;
            TableRelation = Contact WHERE (Type=CONST(Company));

            trigger OnValidate()
            var
                Opp: Record "5092";
                OppEntry: Record "5093";
                Todo: Record "5080";
                InteractLogEntry: Record "5065";
                SegLine: Record "5077";
                SalesHeader: Record "36";
                ChangeLogMgt: Codeunit "423";
                RecRef: RecordRef;
                xRecRef: RecordRef;
            begin
            end;
        }
        field(5052;"Company Name";Text[100])
        {
            Caption = 'Company Name';
            Editable = false;
        }
        field(5053;"Prospect Address";Text[50])
        {
        }
        field(5054;"Phone No.";Text[30])
        {
        }
        field(5055;"Mobile Phone No.";Text[30])
        {
        }
        field(5056;"Contact Person";Code[50])
        {
        }
        field(5060;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
        }
        field(5061;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
        }
        field(5062;"Deal Finalization No.";Code[20])
        {
        }
        field(5063;"Next Appointment Date";Date)
        {
        }
        field(5064;"CDIF Nos.";Code[20])
        {

            trigger OnValidate()
            begin
                /*Rec."CDIF Nos." := NoSeriesMgt.GetNextNo(AccoutabilityCenter."CDIF Nos.",TODAY,TRUE);*/
                
                //NoSeriesMgt.GetNextNo(PayrollHeader."Posting No. Series", PayrollHeader."Posting Date", TRUE);

            end;
        }
        field(5065;"Exchange Required";Option)
        {
            OptionCaption = ' ,Yes,NO,Not Decided';
            OptionMembers = " ",Yes,NO,"Not Decided";
        }
        field(5066;"Finance required";Option)
        {
            OptionCaption = ' ,Yes,NO,Not Decided';
            OptionMembers = " ",Yes,NO,"Not Decided";
        }
        field(5067;"Type of Buyer";Option)
        {
            OptionCaption = ' ,First Time,Repeat,Additional';
            OptionMembers = " ","First Time","Repeat",Additional;
        }
        field(33020620;"HS Code";Code[20])
        {
        }
    }

    keys
    {
        key(Key1;"Prospect No.","Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        // CNY.CRM >>

        ProsPipelineHist_G.RESET;
        ProsPipelineHist_G.SETRANGE("Prospect No.","Prospect No.");
        ProsPipelineHist_G.SETRANGE("Prospect Line No","Line No.");
        IF NOT ProsPipelineHist_G.ISEMPTY THEN
          ERROR('One or more history lines exists with the Prospect');

        // CNY.CRM <<
    end;

    trigger OnInsert()
    begin
        // CNY.CRM

        "Pipeline Code"  := 'F001';
        "Created Date" := TODAY;
        "Last Modified Date" := TODAY;

        IF Contact_G.GET("Prospect No.") THEN BEGIN
          "Company No." := Contact_G."Company No.";
          "Company Name" := Contact_G.Name;
          "Prospect Address" := Contact_G.Address;
          "Phone No." := Contact_G."Phone No.";
          "Mobile Phone No." := Contact_G."Mobile Phone No.";
          "Contact Person" := Contact_G."Contact Person";
        END;

        IF UserSetup_G.GET(USERID) THEN BEGIN
           IF SalesPerson_G.GET(UserSetup_G."Salespers./Purch. Code") THEN BEGIN
            VALIDATE("Vehicle Division",SalesPerson_G."Vehicle Division");
            VALIDATE("Salesperson Code",SalesPerson_G.Code);
           END;
        END;

        // CNY.CRM
    end;

    trigger OnModify()
    begin
        // CNY.CRM >>

        IF ("Pipeline Code" = 'C3') OR ("Pipeline Status" = "Pipeline Status" :: Lost) THEN
          ERROR('You are not allowed to do any modifications for the current prospect when the status is in Lost or PipeLine Code C3');

        // CNY.CRM <<
    end;

    var
        CRMMaster_G: Record "33020143";
        Contact_G: Record "5050";
        SalesPerson_G: Record "13";
        UserSetup_G: Record "91";
        PipeLineDetails_G: Record "33020141";
        ProsPipelineHist_G: Record "33020198";
        LostProspectsPage: Page "33020195";
                               ItemRec: Record "27";
                               CustInteractionLog: Record "33019859";
                               LastEntryNo: Integer;
                               TariffNumberRec: Record "260";

    [Scope('Internal')]
    procedure CopyPipelineData()
    begin
        CustInteractionLog.INIT;
        CustInteractionLog.VALIDATE("Contact No.", "Prospect No.");
        CustInteractionLog."Line No." := "Line No.";
        CustInteractionLog."Pipeline Code" := "Pipeline Code";
        CustInteractionLog.INSERT(TRUE);
    end;

    [Scope('Internal')]
    procedure CreateSalesQuoteFromPipeline(var PipeLineDetail: Record "33020141")
    var
        SalesHdr: Record "36";
        SalesLine: Record "37";
        LineNo: Integer;
    begin
        UserSetup_G.GET(USERID);
        IF PipeLineDetail."Sales Quote No." = '' THEN BEGIN
            SalesHdr.RESET;
            SalesHdr.INIT;
            SalesHdr."Document Type" := SalesHdr."Document Type"::Quote;
            SalesHdr."Document Profile" := SalesHdr."Document Profile"::"Vehicles Trade";
            SalesHdr.VALIDATE("Sell-to Contact No.", PipeLineDetail."Prospect No.");
            SalesHdr."Prospect Line No." := PipeLineDetail."Line No.";
            SalesHdr.VALIDATE("Salesperson Code", PipeLineDetail."Salesperson Code");
            SalesHdr.INSERT(TRUE);
            SalesHdr.VALIDATE("Shortcut Dimension 1 Code", UserSetup_G."Shortcut Dimension 1 Code");
            SalesHdr.VALIDATE("Shortcut Dimension 2 Code", UserSetup_G."Shortcut Dimension 2 Code");
            SalesHdr.MODIFY;

            LineNo := 0;
            IF PipeLineDetail.FINDSET THEN
                REPEAT
                    LineNo += 10000;
                    SalesLine.INIT;
                    SalesLine."Document No." := SalesHdr."No.";
                    SalesLine."Document Type" := SalesHdr."Document Type";
                    SalesLine."Line No." := LineNo;
                    SalesLine.Type := SalesLine.Type::Item;
                    SalesLine."Line Type" := SalesLine."Line Type"::Vehicle;
                    SalesLine.VALIDATE("Make Code", PipeLineDetail."Make Code");
                    SalesLine.VALIDATE("Model Code", PipeLineDetail."Model Code");
                    SalesLine.VALIDATE("Model Version No.", PipeLineDetail."Model Version No.");
                    SalesLine.INSERT(TRUE);
                    PipeLineDetail."Sales Quote No." := SalesHdr."No.";
                    PipeLineDetail."Pipeline Code" := 'C1';
                    PipeLineDetail.MODIFY;
                UNTIL PipeLineDetail.NEXT = 0;
            PAGE.RUN(41, SalesHdr);
        END;
    end;
}

