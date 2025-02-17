table 33019851 "PDI Header"
{
    DataPerCompany = false;

    fields
    {
        field(10; "No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    ProcessChecklistSetup.GET;
                    NoSeriesMgt.TestManual(GetNoSeriesCode);
                END;
            end;
        }
        field(20; "Customer No."; Code[20])
        {
            TableRelation = Customer;

            trigger OnValidate()
            begin
                Cust.RESET;
                Cust.SETRANGE("No.", "Customer No.");
                IF Cust.FINDFIRST THEN BEGIN
                    Name := Cust.Name;
                    Address := Cust.Address;
                END;
            end;
        }
        field(30; Name; Text[50])
        {
            Editable = false;
        }
        field(40; Address; Text[50])
        {
            Editable = false;
        }
        field(50; "Invoice No."; Code[10])
        {
        }
        field(60; "Sales Date"; Date)
        {
        }
        field(70; "PDI Date"; Date)
        {
        }
        field(80; Make; Code[20])
        {
            Editable = false;
            TableRelation = Make;
        }
        field(90; Model; Code[20])
        {
            Editable = false;
            TableRelation = Model;
        }
        field(91; "Model Version No."; Code[20])
        {
        }
        field(100; "Registration No."; Code[20])
        {
            Editable = false;
        }
        field(110; VIN; Code[20])
        {
            Editable = false;
            TableRelation = Vehicle.VIN;
        }
        field(120; "Engine No."; Code[20])
        {
            Editable = false;
        }
        field(130; Kilometrage; Decimal)
        {
            Description = 'to be updated in vehicle card';
        }
        field(140; "Key No."; Code[20])
        {
            Description = 'bring from vehicle card';
        }
        field(141; "PDI Type"; Option)
        {
            OptionCaption = ' ,Regular PDI,Accidental Repair';
            OptionMembers = " ","Regular PDI","Accidental Repair";
        }
        field(150; "Document Type"; Option)
        {
            OptionCaption = ' ,Purchase Order,Transfer Order,Service Order';
            OptionMembers = " ","Purchase Order","Transfer Order","Service Order";
        }
        field(151; "Source ID"; Code[20])
        {
            TableRelation = "Purchase Header".No. WHERE(Document Profile=FILTER(Vehicles Trade));
        }
        field(152;"Tyre F.L No.";Code[30])
        {
        }
        field(153;"Tyre F.R No.";Code[30])
        {
        }
        field(154;"Tyre R.L No.";Code[30])
        {
        }
        field(155;"Tyre R.R. No.";Code[30])
        {
        }
        field(156;"Tyre F.L Size";Code[30])
        {
        }
        field(157;"Tyre F.R Size";Code[30])
        {
        }
        field(158;"Tyre R.L Size";Code[30])
        {
        }
        field(159;"Tyre R.R. Size";Code[30])
        {
        }
        field(160;"Tyre F.L Make";Code[30])
        {
        }
        field(161;"Tyre F.R Make";Code[30])
        {
        }
        field(162;"Tyre R.L Make";Code[30])
        {
        }
        field(163;"Tyre R.R. Make";Code[30])
        {
        }
        field(164;"Tyre Spare No.";Code[30])
        {
        }
        field(165;"Tyre Spare Size";Code[30])
        {
        }
        field(166;"Tyre Spare Make";Code[30])
        {
        }
        field(167;"F.I Pump No.";Code[30])
        {
        }
        field(168;"F.I Pump Make";Code[30])
        {
        }
        field(169;"Speedometer Make";Code[30])
        {
        }
        field(170;"Battery No.";Code[30])
        {
        }
        field(171;"Battery Make";Code[30])
        {
        }
        field(172;"Starter Motor Make";Code[30])
        {
        }
        field(173;"Radiator Make";Code[30])
        {
        }
        field(174;"Alternator Make";Code[30])
        {
        }
        field(175;"S.L No.";Code[30])
        {
        }
        field(176;"G.B No.";Code[30])
        {
        }
        field(177;"F.A No.";Code[30])
        {
        }
        field(178;"T.C No.";Code[30])
        {
        }
        field(179;"R.A No.";Code[30])
        {
        }
        field(180;"No. Series";Code[20])
        {
            Editable = false;
        }
        field(181;Status;Option)
        {
            Editable = false;
            OptionCaption = 'Open,Closed';
            OptionMembers = Open,Closed;
        }
        field(182;Color;Text[30])
        {
        }
        field(183;"Closed Date";DateTime)
        {
        }
        field(184;"Received Date";Date)
        {
        }
        field(185;"Accountability Center";Code[10])
        {
            Editable = false;
            TableRelation = "Accountability Center";
        }
        field(186;"Assigned User ID";Code[50])
        {
            Editable = false;
        }
        field(187;"Injection Pump Make";Code[30])
        {
        }
        field(188;"Injection Serial No.";Code[30])
        {
        }
        field(190;"Starter Serial No.";Code[30])
        {
        }
        field(192;"Alternator Serial No.";Code[30])
        {
        }
        field(193;"Front Tyre Make";Code[30])
        {
        }
        field(194;"Front Tyre Size";Code[30])
        {
        }
        field(195;"F. LH side tyre serial no.";Code[30])
        {
        }
        field(196;"F. RH side tyre serial no.";Code[30])
        {
        }
        field(197;"Rear Tyre Make";Code[30])
        {
        }
        field(198;"Rear Tyre Size";Code[30])
        {
        }
        field(199;"R. LH side tyre serial no.";Code[30])
        {
        }
        field(200;"R. RH side tyre serial no.";Code[30])
        {
        }
        field(202;"Battery Type";Code[30])
        {
        }
        field(203;"Battery Sr. No.";Code[30])
        {
        }
        field(204;"Mobile No.";Text[20])
        {
        }
        field(205;"Turbo Charger Serial No.";Code[30])
        {
        }
        field(206;"Vehicle Serial No.";Code[20])
        {
        }
        field(207;"Motor Serial No.";Code[30])
        {
            Description = '//m-electric';
        }
        field(208;"RF ID Code";Code[30])
        {
            Description = '//m-electric';
        }
        field(209;"Type 1 Charger Serial No.";Code[30])
        {
            Description = '//m-electric';
        }
        field(210;"Type 2 Charger Serial No.";Code[30])
        {
            Description = '//m-electric';
        }
        field(211;"Motor Identification No.";Code[30])
        {
            Description = '//3wheelers';
        }
        field(212;"Battery Pack Serial No.";Code[30])
        {
            Description = '//3wheelers';
        }
        field(213;"Telematics Number";Code[30])
        {
            Description = '//3wheelers';
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
          TestNoSeries;
          NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", 0D, "No.", "No. Series");
        END;

        "Assigned User ID" := USERID;

        UserSetup.RESET;
        UserSetup.SETRANGE("User ID","Assigned User ID");
        IF UserSetup.FINDFIRST THEN BEGIN
           "Accountability Center" := UserSetup."Default Accountability Center";
        END;
    end;

    var
        NoSeriesMgt: Codeunit "396";
        ProcessChecklistSetup: Record "25006009";
        PDIHdr: Record "33019851";
        Text051: Label 'Process checkilst %1 already exists.';
        Text010: Label 'You cannot change %1 while lines exist.';
        Cust: Record "18";
        UserSetup: Record "91";
        VehRec: Record "25006005";

    [Scope('Internal')]
    procedure AssistEdit(OldPDIHdr: Record "33019851"): Boolean
    var
        PDIHdr2: Record "33019851";
    begin
        WITH PDIHdr DO BEGIN
          COPY(Rec);
          ProcessChecklistSetup.GET;
          TestNoSeries;
          IF NoSeriesMgt.SelectSeries(ProcessChecklistSetup."PDI Nos.",
             OldPDIHdr."No. Series","No. Series") THEN BEGIN
            NoSeriesMgt.SetSeries("No.");
            IF PDIHdr2.GET("No.") THEN
              ERROR(Text051,"No.");
            Rec := PDIHdr;
            EXIT(TRUE);
          END;
        END;
    end;

    local procedure TestNoSeries(): Boolean
    begin
        ProcessChecklistSetup.GET;
        ProcessChecklistSetup.TESTFIELD("PDI Nos.");
    end;

    local procedure GetNoSeriesCode(): Code[10]
    begin
        EXIT(ProcessChecklistSetup."PDI Nos.");
    end;
}

