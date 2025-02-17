table 33020237 "Warranty App. Journal Line"
{

    fields
    {
        field(10; "Claim No."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(15; "Serv. Order No."; Code[20])
        {
        }
        field(20; VIN; Code[20])
        {
        }
        field(25; "Make Code"; Code[20])
        {
            TableRelation = Make;
        }
        field(30; "Model Code"; Code[20])
        {
            TableRelation = Model;
        }
        field(35; "Model Version No."; Code[20])
        {
            TableRelation = Item.No. WHERE(Make Code=FIELD(Make Code),
                                            Model Code=FIELD(Model Code),
                                            Item Type=CONST(Model Version));
        }
        field(40;"Sell to Customer No.";Code[20])
        {
            TableRelation = Customer;
        }
        field(45;"Bill to Customer No.";Code[20])
        {
            TableRelation = Customer;
        }
        field(46;Type;Option)
        {
            OptionCaption = ' ,Item,Labor';
            OptionMembers = " ",Item,Labor;
        }
        field(50;"Item No.";Code[20])
        {
            TableRelation = Item WHERE (Item Type=CONST(Item));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(51;"Item Name";Text[50])
        {
        }
        field(55;"Job Type";Code[20])
        {
        }
        field(60;"Aggregate Job Type";Code[20])
        {
        }
        field(65;"Aggregate Service Type";Option)
        {
            OptionCaption = ' ,1st type Service,2nd type Service,3rd type Service,4th type Service,5th type Service,Other';
            OptionMembers = " ","1st type Service","2nd type Service","3rd type Service","4th type Service","5th type Service",Other;
        }
        field(68;Status;Option)
        {
            OptionCaption = ' ,Pending,Approved,Rejected';
            OptionMembers = " ",Pending,Approved,Rejected;
        }
        field(70;"Approved By";Code[50])
        {
        }
        field(72;"Requested By";Code[50])
        {
        }
        field(75;"Approved Date";Date)
        {
        }
        field(80;"Reason Code";Code[250])
        {
        }
        field(81;"Warranty Code";Code[10])
        {
            TableRelation = "Customer Complain Master".No.;
        }
        field(82;"Warranty Description";Text[100])
        {
            CalcFormula = Lookup("Customer Complain Master".Description WHERE (No.=FIELD(Warranty Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(85;"Complain Date";Date)
        {
            Caption = 'Complain Date';
        }
        field(90;Quantity;Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0:5;
        }
        field(95;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = IF (Type=CONST(Item)) "Item Unit of Measure".Code WHERE (Item No.=FIELD(Item No.))
                            ELSE "Unit of Measure";
        }
        field(100;Amount;Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
        }
        field(105;"Gen. Bus. Posting Group";Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(110;"Gen. Prod. Posting Group";Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(115;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(1));
        }
        field(120;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE (Global Dimension No.=CONST(2));
        }
        field(125;Location;Code[10])
        {
        }
        field(130;"Responsibility Center";Code[10])
        {
        }
        field(135;Exported;Boolean)
        {
        }
        field(140;"No. Series";Code[10])
        {
        }
        field(150;Approve;Boolean)
        {

            trigger OnValidate()
            begin
                IF Approve = TRUE THEN BEGIN
                  "Approved Date" := TODAY;
                  "Approved By" := USERID;
                END
                ELSE BEGIN
                  "Approved Date" := 0D;
                  "Approved By" := '';
                END;
            end;
        }
        field(153;"New Claim No.";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(154;"Posting No. Series";Code[10])
        {
        }
        field(158;Kilometrage;Decimal)
        {
        }
        field(160;"Vehicle Sales Date";Date)
        {
        }
        field(161;"Complaint Report Date";Date)
        {
        }
        field(165;"Veh. Regd. No.";Code[20])
        {
        }
        field(167;"Job Date";Date)
        {
        }
        field(168;"Unit Price";Decimal)
        {
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(50005;"Labor Code (System)";Code[20])
        {
        }
        field(33019961;"Accountability Center";Code[10])
        {
            Editable = false;
            TableRelation = "Accountability Center";
        }
    }

    keys
    {
        key(Key1;"Claim No.")
        {
            Clustered = true;
        }
        key(Key2;"Serv. Order No.")
        {
        }
        key(Key3;"Aggregate Job Type")
        {
        }
        key(Key4;"Global Dimension 1 Code","Global Dimension 2 Code")
        {
        }
        key(Key5;"Responsibility Center",Location,"Complain Date")
        {
        }
        key(Key6;"Warranty Code")
        {
        }
        key(Key7;"Item No.")
        {
        }
        key(Key8;Status)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        ServMgtSetup.GET;
        IF "Claim No." = '' THEN BEGIN
          TestNoSeries;
          NoSeriesMngt.InitSeries(GetNoSeries,xRec."No. Series",0D,"Claim No.","No. Series");
        END;
        //InitRecord;
    end;

    var
        NoSeriesMngt: Codeunit "396";
        ServMgtSetup: Record "25006120";

    [Scope('Internal')]
    procedure TestNoSeries(): Boolean
    begin
        ServMgtSetup.TESTFIELD("Warranty Nos.");
    end;

    [Scope('Internal')]
    procedure GetNoSeries(): Code[20]
    begin
        EXIT(ServMgtSetup."Warranty Nos.");
    end;

    [Scope('Internal')]
    procedure ApproveWarranty()
    var
        WarrantyRegister: Record "33020238";
        WarrAppLines: Record "33020237";
        UserSetup: Record "91";
        Text000: Label 'You dont have permission to approve warranty entries.';
        RecordsModified: Boolean;
        Text001: Label 'Warranty Approval/Rejection Successfully done.';
        Text002: Label 'There is no entries for Approval.';
        Vehicle: Record "25006005";
    begin
        UserSetup.GET(USERID);
        RecordsModified := FALSE;
        IF UserSetup."Warranty Approver" THEN BEGIN
          // Processing Approved Lines.
          WarrAppLines.RESET;
          WarrAppLines.SETCURRENTKEY(Status);
          WarrAppLines.SETRANGE(Status,WarrAppLines.Status::Approved);
          IF WarrAppLines.FINDSET THEN BEGIN
            REPEAT
               CLEAR(WarrantyRegister);
               GetNewClaimNo(WarrAppLines);
               WarrantyRegister.INIT;
               WarrantyRegister.TRANSFERFIELDS(WarrAppLines);
               WarrantyRegister."Prowac Dealer" := GetProwacDealerCode(WarrantyRegister.Location);
               WarrantyRegister."Sale Dealer Code" := GetProwacDealerCode(WarrantyRegister.Location);
               WarrantyRegister."Prowac Year" := GetFiscalYear;
               WarrantyRegister."Customer Category" := WarrantyRegister."Customer Category"::"1.Retail Customer";
               WarrantyRegister."Status Code" := WarrantyRegister."Status Code"::"2.Sold";
               WarrantyRegister."Claim Category" := WarrantyRegister."Claim Category"::"1.Normal Warranty";
               WarrantyRegister."Failure Code" := WarrantyRegister."Failure Code"::"1.OE Failure";
               WarrantyRegister."Operation Type" := WarrantyRegister."Operation Type"::"2.Long Route";
               WarrantyRegister."Road Type" := WarrantyRegister."Road Type"::"1.Plain Metalled";
               WarrantyRegister."Action Taken" := 'PARTS REPLACED FROM OUR STOCK';
               WarrantyRegister."Supply Source" := WarrantyRegister."Supply Source"::"1.Stock";
               WarrantyRegister.Approved := TRUE;
               WarrantyRegister."Approved By" := USERID;
               WarrantyRegister."Approved Date" := TODAY;
               WarrantyRegister."Posting Date" := TODAY;
               Vehicle.RESET;
               Vehicle.SETRANGE(VIN,WarrAppLines.VIN);
               WarrantyRegister."Vehicle Sales Date" := Vehicle."Sales Date";
               WarrantyRegister.INSERT;
               UpdateServiceLines(WarrAppLines."Claim No.",TRUE);
               RecordsModified := TRUE;
            UNTIL WarrAppLines.NEXT=0;
            WarrAppLines.DELETEALL;
          END;
          //Processing Rejected Lines.
          WarrAppLines.RESET;
          WarrAppLines.SETCURRENTKEY(Status);
          WarrAppLines.SETRANGE(Status,WarrAppLines.Status::Rejected);
          IF WarrAppLines.FINDSET THEN BEGIN
            REPEAT
               CLEAR(WarrantyRegister);
               WarrantyRegister.INIT;
               WarrantyRegister.TRANSFERFIELDS(WarrAppLines);
               WarrantyRegister."Approved By" := USERID;
               WarrantyRegister."Posting Date" := TODAY;
               WarrantyRegister.INSERT;
               UpdateServiceLines(WarrAppLines."Claim No.",FALSE);
               RecordsModified := TRUE;
            UNTIL WarrAppLines.NEXT=0;
            WarrAppLines.DELETEALL;
          END;
          IF RecordsModified THEN
            MESSAGE(Text001)
          ELSE
            ERROR(Text002);
        END
        ELSE
          ERROR(Text000);
    end;

    [Scope('Internal')]
    procedure UpdateServiceLines(ClaimNo: Code[20];Approved: Boolean)
    var
        ServiceLine: Record "25006146";
    begin
        ServiceLine.RESET;
        ServiceLine.SETRANGE("Warranty Claim No.",ClaimNo);
        IF ServiceLine.FINDSET THEN BEGIN
          ServiceLine.VALIDATE("Warranty Approved",Approved);
          ServiceLine.MODIFY;
        END;
    end;

    [Scope('Internal')]
    procedure InitRecord()
    begin
        //"New Claim No." := ServMgtSetup."Warranty Register Nos.";
    end;

    [Scope('Internal')]
    procedure GetNewClaimNo(var WarrantyAppLine: Record "33020237")
    var
        WarrRegister: Record "33020238";
        WarrHeader: Record "33020249";
    begin
        WarrRegister.RESET;
        WarrRegister.SETCURRENTKEY("Serv. Order No.");
        WarrRegister.SETRANGE("Serv. Order No.",WarrantyAppLine."Serv. Order No.");
        IF WarrRegister.FINDFIRST THEN
          WarrantyAppLine."New Claim No." := WarrRegister."No."
        ELSE BEGIN
          ServMgtSetup.GET;
          ServMgtSetup.TESTFIELD("Warranty Register Nos.");
          NoSeriesMngt.InitSeries(ServMgtSetup."Warranty Register Nos.",xRec."Posting No. Series",0D,
                          WarrantyAppLine."New Claim No.","Posting No. Series");
          CLEAR(WarrHeader);
          WarrHeader.INIT;
          WarrHeader."Claim No." := WarrantyAppLine."Claim No.";
          WarrHeader."No." := WarrantyAppLine."New Claim No.";
          WarrHeader."Prowac Year" := GetFiscalYear;
          WarrHeader."Service Order No." := WarrantyAppLine."Serv. Order No.";
          WarrHeader."Responsibility Center" := WarrantyAppLine."Responsibility Center";
          WarrHeader."Accountability Center" := WarrantyAppLine."Accountability Center";
          WarrHeader."Location Code" := WarrantyAppLine.Location;
          WarrHeader."Make Code" := WarrantyAppLine."Make Code";
          WarrHeader."Prowac Dealer Code" :=  GetProwacDealerCode(WarrantyAppLine.Location);
          WarrHeader."Sell to Customer No." := WarrantyAppLine."Sell to Customer No.";
          WarrHeader."Bill to Customer No." := WarrantyAppLine."Bill to Customer No.";
          WarrHeader.INSERT;
        END;
        WarrantyAppLine.MODIFY;
    end;

    [Scope('Internal')]
    procedure GetProwacDealerCode(LocationCode: Code[10]): Code[30]
    var
        ProwacDealerMapping: Record "33020248";
    begin
        ProwacDealerMapping.RESET;
        IF ProwacDealerMapping.GET(LocationCode) THEN
          EXIT(ProwacDealerMapping."Prowac Dealer Code");
    end;

    [Scope('Internal')]
    procedure GetFiscalYear(): Integer
    var
        InputDate: Date;
        Day: Integer;
        Month: Integer;
        Year: Integer;
    begin
        InputDate := TODAY;
        Day := DATE2DMY(InputDate,1);
        Month := DATE2DMY(InputDate,2);
        Year := DATE2DMY(InputDate,3);
        IF Month>3 THEN
          EXIT(Year)
        ELSE
          EXIT(Year-1)
    end;
}

