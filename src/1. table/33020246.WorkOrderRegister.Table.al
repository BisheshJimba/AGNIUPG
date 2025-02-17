table 33020246 "Work Order Register"
{

    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionCaption = 'Work Order';
            OptionMembers = "Work Order";
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Service Order No."; Code[20])
        {
            Editable = false;
        }
        field(4; "Vendor No."; Code[20])
        {
            Editable = false;
            TableRelation = Vendor;
        }
        field(5; "Vendor Name"; Text[50])
        {
            CalcFormula = Lookup(Vendor.Name WHERE(No.=FIELD(Vendor No.)));
            FieldClass = FlowField;
        }
        field(6;Location;Code[10])
        {
            Editable = false;
            TableRelation = Location;
        }
        field(7;"Item Type";Option)
        {
            OptionCaption = 'Engine,Head,Block,Body,FIP,Nozzle,Alternator,Starter Motor,Pressure Plate,Fly Wheel,Idler Arm Bush,Break Disc,Chassis Frame,Diesel';
            OptionMembers = Engine,Head,Block,Body,FIP,Nozzle,Alternator,"Starter Motor","Pressure Plate","Fly Wheel","Idler Arm Bush","Break Disc","Chassis Frame",Diesel;
        }
        field(8;"Work Order Type";Option)
        {
            OptionCaption = 'Returnable,Non-Returnable';
            OptionMembers = Returnable,"Non-Returnable";
        }
        field(10;"Responsibility Center";Code[10])
        {
        }
        field(11;"Issued By";Code[50])
        {
        }
        field(12;"Vehicle Reg. No.";Code[20])
        {
        }
        field(13;"Vehicle Chassis No.";Code[20])
        {
        }
        field(14;"Description 1";Text[250])
        {
        }
        field(15;"Description 2";Text[250])
        {
        }
        field(16;"Description 3";Text[250])
        {
        }
        field(17;"Description 4";Text[250])
        {
        }
        field(18;"Work Order Subject";Text[50])
        {
        }
        field(50000;"Internal Service";Boolean)
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
        key(Key1;"Service Order No.","Line No.")
        {
            Clustered = true;
        }
        key(Key2;"Item Type")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //delete is required.
    end;

    trigger OnInsert()
    begin
        "Issued By" := USERID;
        ServiceHeader.RESET;
        ServiceHeader.SETRANGE("Document Type",ServiceHeader."Document Type"::Order);
        ServiceHeader.SETRANGE("No.","Service Order No.");
        IF ServiceHeader.FINDFIRST THEN BEGIN
          Location := ServiceHeader."Location Code";
          "Responsibility Center" := ServiceHeader."Responsibility Center";
          "Accountability Center" := ServiceHeader."Accountability Center";
          "Vehicle Reg. No." := ServiceHeader."Vehicle Registration No.";
          "Vehicle Chassis No." := ServiceHeader.VIN;
        END;
        IF "Internal Service" THEN BEGIN
           IF ExtService.GET('EXT119') THEN BEGIN
            ExtServTrackingNos.RESET;
            ExtServTrackingNos.SETRANGE("External Service No.",'EXT119');
            ExtServTrackingNos.SETRANGE("External Serv. Tracking No.",'TRK-00112');
            IF ExtServTrackingNos.FINDFIRST THEN
              "Work Order Subject" := ExtServTrackingNos.Description;
            "Vendor No." := ExtService."Vendor No.";
           END;
        END
        ELSE IF (NOT "Internal Service") THEN BEGIN
          ServiceLine.RESET;
          ServiceLine.SETRANGE("Document Type",ServiceLine."Document Type"::Order);
          ServiceLine.SETRANGE("Document No.",ServiceHeader."No.");
          ServiceLine.SETRANGE(Type,ServiceLine.Type::"External Service");
          ServiceLine.SETRANGE("Work Order Registered",FALSE);
          IF ServiceLine.FINDFIRST THEN BEGIN
            ExtService.RESET;
            IF ExtService.GET(ServiceLine."No.") THEN  BEGIN
              ExtServTrackingNos.RESET;
              ExtServTrackingNos.SETRANGE("External Service No.",ServiceLine."No.");
              ExtServTrackingNos.SETRANGE("External Serv. Tracking No.",ServiceLine."External Serv. Tracking No.");
              IF ExtServTrackingNos.FINDFIRST THEN
                "Work Order Subject" := ExtServTrackingNos.Description;
              "Vendor No." := ExtService."Vendor No.";
            END;
            ServiceLine."Work Order Registered" := TRUE;
            ServiceLine.MODIFY;
          END
          ELSE
            ERROR(Text000);
        END;
    end;

    var
        ServiceHeader: Record "25006145";
        ServiceLine: Record "25006146";
        ExtService: Record "25006133";
        Text000: Label 'There is no External Services withing the filter or all entries have been created.';
        ExtServTrackingNos: Record "25006153";

    [Scope('Internal')]
    procedure SplitWorkOrderDetails(WorkOrderDetails: Text[1000];var WOR: Record "33020246")
    var
        TruncLen: Integer;
        TotalLen: Integer;
    begin
        WOR."Description 1" := '';
        WOR."Description 2" := '';
        WOR."Description 3" := '';
        WOR."Description 4" := '';
        MODIFY;
        TotalLen := STRLEN(WorkOrderDetails);
        IF TotalLen <= 250 THEN
         WOR."Description 1" := WorkOrderDetails
        ELSE
          WOR."Description 1" := PADSTR(WorkOrderDetails,250);
        TruncLen := STRLEN(WOR."Description 1");
        IF TruncLen < TotalLen THEN BEGIN
          WOR."Description 2" := DELSTR(WorkOrderDetails,TruncLen+1,250);
          TruncLen := STRLEN(WOR."Description 1")+ STRLEN(WOR."Description 2");
          IF TruncLen < TotalLen THEN BEGIN
            WOR."Description 3" := DELSTR(WorkOrderDetails,TruncLen+1,250);
            TruncLen :=  STRLEN(WOR."Description 1")+ STRLEN(WOR."Description 2") + STRLEN(WOR."Description 3");
            IF TruncLen < TotalLen THEN
              WOR."Description 4" := DELSTR(WorkOrderDetails,TruncLen+1,250);
          END;
        END;
        MODIFY;
    end;

    [Scope('Internal')]
    procedure GetWorkOrderDetails(WOR: Record "33020246") WorkOrder: Text[1000]
    var
        WorkOrderTemplate: Record "33020239";
    begin
        WorkOrder := WOR."Description 1" + WOR."Description 2" + WOR."Description 3" + WOR."Description 4";
        IF WorkOrder = '' THEN BEGIN
          WorkOrderTemplate.RESET;
          WorkOrderTemplate.SETRANGE("Text Position",WorkOrderTemplate."Text Position"::Body);
          IF WorkOrderTemplate.FINDFIRST THEN
            REPEAT
              WorkOrder += WorkOrderTemplate.Description;
            UNTIL WorkOrderTemplate.NEXT = 0;
        END;
    end;
}

