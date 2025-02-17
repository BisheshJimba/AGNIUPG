table 33020238 "Warranty Register"
{

    fields
    {
        field(10; "Claim No."; Code[20])
        {
            Editable = true;
        }
        field(15; "Serv. Order No."; Code[20])
        {
            Editable = true;
        }
        field(20; VIN; Code[20])
        {
            Editable = true;
        }
        field(25; "Make Code"; Code[20])
        {
            Editable = true;
            TableRelation = Make;
        }
        field(30; "Model Code"; Code[20])
        {
            Editable = true;
            TableRelation = Model.Code;
        }
        field(35; "Model Version No."; Code[20])
        {
            Editable = true;
            TableRelation = Item.No. WHERE(Make Code=FIELD(Make Code),
                                            Model Code=FIELD(Model Code),
                                            Item Type=CONST(Model Version));
        }
        field(40;"Sell to Customer No.";Code[20])
        {
            Editable = true;
            TableRelation = Customer;
        }
        field(45;"Bill to Customer No.";Code[20])
        {
            Editable = true;
            TableRelation = Customer;
        }
        field(46;Type;Option)
        {
            Editable = true;
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
            Editable = true;
            TableRelation = "Gen. Business Posting Group";
        }
        field(110;"Gen. Prod. Posting Group";Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            Editable = true;
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
            Editable = true;
        }
        field(130;"Responsibility Center";Code[10])
        {
            Editable = true;
        }
        field(135;Exported;Boolean)
        {
        }
        field(140;"No. Series";Code[20])
        {
        }
        field(150;Approved;Boolean)
        {
        }
        field(151;"Posting Date";Date)
        {
        }
        field(153;"No.";Code[20])
        {
            Editable = true;
        }
        field(154;"Prowac Dealer";Text[30])
        {
        }
        field(155;"Prowac Year";Integer)
        {
        }
        field(157;"Sale Dealer Code";Code[20])
        {
        }
        field(158;Kilometrage;Decimal)
        {
        }
        field(160;"Vehicle Sales Date";Date)
        {
            Editable = true;
        }
        field(161;"Complaint Report Date";Date)
        {
        }
        field(163;"PCR Date";Date)
        {
            CalcFormula = Lookup("Posted Serv. Order Header"."Posting Date" WHERE (Order No.=FIELD(Serv. Order No.)));
            Description = 'Job Closed Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(165;"Veh. Regd. No.";Code[20])
        {
            Editable = true;
        }
        field(166;"Customer Name";Text[70])
        {
            CalcFormula = Lookup(Customer.Name WHERE (No.=FIELD(Sell to Customer No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(167;"Job Date";Date)
        {
        }
        field(168;"Unit Price";Decimal)
        {
        }
        field(190;"Customer Category";Option)
        {
            OptionCaption = ' ,1.Retail Customer,2.STUs,3.Govt.,4.Organisation,5.Army';
            OptionMembers = " ","1.Retail Customer","2.STUs","3.Govt.","4.Organisation","5.Army";
        }
        field(191;"Status Code";Option)
        {
            OptionCaption = ' ,1.Drive Away,2.Sold';
            OptionMembers = " ","1.Drive Away","2.Sold";
        }
        field(192;"Claim Category";Option)
        {
            OptionCaption = '0.M and HCV Engine,1.Normal Warranty,2.Repeat Failure,3.Goodwill - Commercial,4.Retrofitment,5.PIW,6.Industrial Engine,7.Drive Away,8.Pre Sale Total,9.Spare Parts Claim,a.Insurance Claim,b.Goodwill - Technical,c.Goodwill - Spares,d.Atlas Copco,e.207 DI Engine,f.Paid Jobs,g.Recon Warranty';
            OptionMembers = "0.M and HCV Engine","1.Normal Warranty","2.Repeat Failure","3.Goodwill - Commercial","4.Retrofitment","5.PIW","6.Industrial Engine","7.Drive Away","8.Pre Sale Total","9.Spare Parts Claim","a.Insurance Claim","b.Goodwill - Technical","c.Goodwill - Spares","d.Atlas Copco","e.207 DI Engine","f.Paid Jobs","g.Recon Warranty";
        }
        field(193;"Failure Code";Option)
        {
            OptionCaption = ' ,1.OE Failure,2.Repeat Failure';
            OptionMembers = " ","1.OE Failure","2.Repeat Failure";
        }
        field(194;"Operation Type";Option)
        {
            OptionCaption = ' ,1.Drive Away Chassis,2.Long Route,3.City Route,4.Construction,5.Mining,6.Forest,7.Marine,8.Others';
            OptionMembers = " ","1.Drive Away Chassis","2.Long Route","3.City Route","4.Construction","5.Mining","6.Forest","7.Marine","8.Others";
        }
        field(195;"Road Type";Option)
        {
            OptionCaption = ' ,1.Plain Metalled,2.Plain Kutcha,3.Off Road,4.Hilly Metalled,5.Hilly Kutcha,6.Desert,7.Others';
            OptionMembers = " ","1.Plain Metalled","2.Plain Kutcha","3.Off Road","4.Hilly Metalled","5.Hilly Kutcha","6.Desert","7.Others";
        }
        field(196;"Complaint Description";Text[240])
        {
        }
        field(197;"Investigation 1";Text[240])
        {
        }
        field(198;"Investigation 2";Text[240])
        {
        }
        field(199;"Action Taken";Text[240])
        {
        }
        field(200;"Aggregate No.";Text[15])
        {
        }
        field(201;"Supply Source";Option)
        {
            OptionCaption = '0.Only Labour,1.Stock,2.Float,3.Local Purchase';
            OptionMembers = "0.Only Labour","1.Stock","2.Float","3.Local Purchase";
        }
        field(202;"Pay Load";Text[30])
        {
        }
        field(203;"Make Code Fail";Text[30])
        {
        }
        field(204;"Make Code Replace";Text[30])
        {
        }
        field(205;"No. of Jobs";Integer)
        {
        }
        field(207;"Lab Amt.";Decimal)
        {
        }
        field(208;"Spl. Lab Chgs.";Decimal)
        {
        }
        field(209;"SPD Invoice No.";Code[20])
        {
        }
        field(210;"SPD Invoice Dt.";Date)
        {
        }
        field(211;"Repair Date";Date)
        {
        }
        field(212;"Job Code";Text[30])
        {
        }
        field(213;Export;Boolean)
        {
        }
        field(214;"Complaint Code";Code[10])
        {
        }
        field(480;"Dimension Set ID";Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(50000;"Not Loaded Reason";Code[50])
        {

            trigger OnValidate()
            begin
                IF Export THEN
                  "Not Loaded Reason" := '';
            end;
        }
        field(50001;"Tata Claim No.";Code[20])
        {
            Description = '//For PCD Only';
        }
        field(50002;"Credit Note No.";Code[20])
        {
            Description = '//For PCD Only';
        }
        field(50003;"Item Description";Text[30])
        {
            CalcFormula = Lookup(Item.Description WHERE (No.=FIELD(Item No.)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50004;Remarks;Text[250])
        {
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
        key(Key8;"No.")
        {
        }
        key(Key9;"Model Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        NoSeriesMngt: Codeunit "396";
        ServMgtSetup: Record "25006120";
        Text000: ;

    [Scope('Internal')]
    procedure TestNoSeries(): Boolean
    begin
    end;

    [Scope('Internal')]
    procedure GetNoSeries(): Code[20]
    begin
    end;

    [Scope('Internal')]
    procedure ApproveWarranty(WarrantyAppLines: Record "33020237")
    var
        WarrantyRegister: Record "33020238";
    begin
    end;
}

