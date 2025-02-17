codeunit 25006870 "TCard Management"
{

    trigger OnRun()
    begin
    end;

    var
        CantMoveOrderToBookingErr: Label 'It''s not possible to convert Order to Booking.';
        ValidateResourceWorktimeErr: Label 'Resource %1 have to start work time first.';
        LocationCode: Code[20];
        EditMode: Boolean;
        NewContainerTxt: Label 'New Container';

    [Scope('Internal')]
    procedure ItemToContainerChange(ContainerEntryNo: Integer; ItemEntryNo: Code[20]; ItemEntryType: Option)
    var
        ServiceBooking: Record "25006145";
        ServiceOrder: Record "25006145";
        TCardContainer: Record "25006870";
        ServiceBookingToOrder: Codeunit "25006871";
        ResourceTimeRegMgt: Codeunit "25006290";
    begin
        IF TCardContainer.GET(ContainerEntryNo) THEN BEGIN
            IF ServiceBooking.GET(ItemEntryType, ItemEntryNo) THEN BEGIN
                IF (TCardContainer.Type = TCardContainer.Type::Booking) AND
                  (ServiceBooking."Document Type" <> ServiceBooking."Document Type"::Booking) THEN BEGIN
                    ERROR(CantMoveOrderToBookingErr);
                END;
                IF (TCardContainer.Type = TCardContainer.Type::Order) AND
                  (ServiceBooking."Document Type" <> ServiceBooking."Document Type"::Order) THEN BEGIN
                    //Convert Booking to order
                    ServiceBooking."TCard Container Entry No." := ContainerEntryNo;
                    IF ServiceBookingToOrder.ServiceBookingToOrderYN(ServiceBooking, ServiceOrder) THEN BEGIN
                        ServiceOrder."TCard Container Entry No." := ContainerEntryNo;
                        ServiceOrder.MODIFY;
                        //Create allocation
                        AddAllocationForOrder(ServiceOrder);
                    END;
                END ELSE BEGIN
                    ServiceBooking."TCard Container Entry No." := ContainerEntryNo;
                    ServiceBooking.MODIFY;
                END;
            END;
        END;
    end;

    [Scope('Internal')]
    procedure FillAddInData(var AddInDataToFill: BigText)
    var
        OutStreamData: OutStream;
        InStreamData: InStream;
        ExportXmlPort: XMLport "25006870";
        TempBlob: Record "99008535" temporary;
        StreamReader: DotNet StreamReader;
    begin
        CLEAR(AddInDataToFill);
        TempBlob.INIT;
        TempBlob.INSERT;
        TempBlob.Blob.CREATEOUTSTREAM(OutStreamData);
        ExportXmlPort.SetEditMode(EditMode);
        ExportXmlPort.SetLocationCode(LocationCode);
        ExportXmlPort.SETDESTINATION(OutStreamData);
        IF ExportXmlPort.EXPORT THEN BEGIN
            TempBlob.CALCFIELDS(Blob);
            TempBlob.Blob.CREATEINSTREAM(InStreamData);
            StreamReader := StreamReader.StreamReader(InStreamData, TRUE);
            AddInDataToFill.ADDTEXT(StreamReader.ReadToEnd());
        END;
    end;

    [Scope('Internal')]
    procedure AddAllocationForOrder(ServiceHeader: Record "25006145")
    var
        ServLaborAllocationEntry: Record "25006271";
        ServLaborAllocationApp: Record "25006277";
        ServiceLine: Record "25006146" temporary;
        ResourceNo: Code[20];
        StartDateTime: Decimal;
        QtyToAllocate: Decimal;
        Duration: Duration;
        DivideIntoLines: Boolean;
        WhatAllocation: Option Header,Line;
        SourceType: Option ,"Service Document","Standard Event";
        Mode: Option "New Allocation","Move Existing","Split Existing","Break";
        LineNo: Integer;
        SourceSubType: Option Qoute,"Order";
        SourceID: Code[20];
        EntryNo: Integer;
        AllocationForm: Page "25006369";
        AllocatedEntryNo: Integer;
        WorkTimeEntry: Record "25006276";
        ServiceScheduleSetup: Record "25006286";
        DateTimeMgt: Codeunit "25006012";
        ServiceScheduleMgt: Codeunit "25006201";
    begin
        ServiceScheduleSetup.GET;
        ResourceNo := ServiceHeader."Booking Resource No.";

        /*
        WorkTimeEntry.RESET;
        WorkTimeEntry.SETCURRENTKEY("Resource No.",Closed);
        WorkTimeEntry.SETRANGE("Resource No.", ResourceNo);
        WorkTimeEntry.SETRANGE(Closed,FALSE);
        IF NOT WorkTimeEntry.FINDLAST THEN
          ERROR(STRSUBSTNO(ValidateResourceWorktimeErr, ResourceNo));
        */

        StartDateTime := DateTimeMgt.Datetime(WORKDATE, TIME);
        DivideIntoLines := FALSE;
        SourceType := ServLaborAllocationEntry."Source Type"::"Service Document";
        Mode := Mode::"New Allocation";
        SourceSubType := ServiceHeader."Document Type";
        SourceID := ServiceHeader."No.";
        CLEAR(ServiceScheduleMgt);

        //ServiceScheduleMgt.CheckForCorrectServHeaderLine(ServiceHeader, ServiceLine, WhatAllocation::Header);
        ServiceLine.SETRANGE("Document Type", ServiceHeader."Document Type");
        ServiceLine.SETRANGE("Document No.", ServiceHeader."No.");
        ServiceLine.SETRANGE("Line No.", 0);

        CLEAR(AllocationForm);
        AllocationForm.SetParam(0, ResourceNo, StartDateTime, 0, SourceType, SourceSubType, SourceID, 0, ServiceLine, 0);
        AllocationForm.SetInvisibles(1);
        AllocatedEntryNo := AllocationForm.Allocate;
        //IF ServLaborAllocationEntry.GET(AllocatedEntryNo) THEN
        //  AddTimeRegEntry('Start',ServLaborAllocationEntry,ResourceNo);

    end;

    [EventSubscriber(ObjectType::Page, 25006355, 'OnAllocationChangeStatus', '', false, false)]
    [Scope('Internal')]
    procedure ProcessTCardItemOnAllocationsStatusChange(Status: Option Pending,"In Process","Finish All","Finish Part","On Hold"; AllocEntryNo: Integer)
    var
        LaborAllocEntry: Record "25006271";
        ServiceOrder: Record "25006145";
        TCardContainer: Record "25006870";
        ResourceTimeRegMgt: Codeunit "25006290";
        CurrentUserResourceNo: Code[20];
        MoveToContainerNo: Integer;
    begin
        IF LaborAllocEntry.GET(AllocEntryNo) THEN
            IF (LaborAllocEntry."Source ID" <> '') AND (LaborAllocEntry."Source Subtype" = LaborAllocEntry."Source Subtype"::Order) THEN
                IF ServiceOrder.GET(ServiceOrder."Document Type"::Order, LaborAllocEntry."Source ID") THEN BEGIN
                    CASE Status OF
                        Status::"In Process":
                            BEGIN
                                //Change Order to TCards Container Resource
                                IF LaborAllocEntry."Resource No." <> '' THEN BEGIN
                                    //CurrentUserResourceNo := ResourceTimeRegMgt.GetCurrentUserResourceNo;
                                    CurrentUserResourceNo := LaborAllocEntry."Resource No.";
                                    MoveToContainerNo := GetResourceContainerNo(CurrentUserResourceNo, ServiceOrder."Location Code");
                                    IF MoveToContainerNo <> 0 THEN BEGIN
                                        ServiceOrder."TCard Container Entry No." := MoveToContainerNo;
                                        ServiceOrder.MODIFY;
                                    END;
                                END;
                            END;
                        Status::"Finish All":
                            BEGIN
                                //Change Order to TCards Container Service Person
                                IF ServiceOrder."Service Person" <> '' THEN BEGIN
                                    MoveToContainerNo := GetServPersContainerNo(ServiceOrder."Service Person", ServiceOrder."Location Code");
                                    ServiceOrder."TCard Container Entry No." := MoveToContainerNo;
                                    ServiceOrder.MODIFY;
                                END;
                            END;
                    END;
                END;
    end;

    local procedure GetResourceContainerNo(ResourceNo: Code[20]; LocationCode: Code[20]): Integer
    var
        TCardContainer: Record "25006870";
    begin
        TCardContainer.RESET;
        TCardContainer.SETRANGE(Enabled, TRUE);
        TCardContainer.SETRANGE(Subtype, TCardContainer.Subtype::"In Progress");
        TCardContainer.SETRANGE(Type, TCardContainer.Type::Order);
        TCardContainer.SETRANGE("Resource No.", ResourceNo);
        TCardContainer.SETRANGE("Location Code", LocationCode);
        IF NOT TCardContainer.FINDFIRST THEN BEGIN
            TCardContainer.SETRANGE("Resource No.", '');
            IF TCardContainer.FINDFIRST THEN;
        END;
        EXIT(TCardContainer."No.");
    end;

    local procedure GetServPersContainerNo(ServPersNo: Code[20]; LocationCode: Code[20]): Integer
    var
        TCardContainer: Record "25006870";
    begin
        TCardContainer.RESET;
        TCardContainer.SETRANGE(Enabled, TRUE);
        TCardContainer.SETRANGE(Subtype, TCardContainer.Subtype::"In Progress");
        TCardContainer.SETRANGE(Type, TCardContainer.Type::Order);
        TCardContainer.SETRANGE("Service Advisor", ServPersNo);
        TCardContainer.SETRANGE("Location Code", LocationCode);
        IF NOT TCardContainer.FINDFIRST THEN BEGIN
            TCardContainer.SETRANGE("Service Advisor", '');
            IF TCardContainer.FINDFIRST THEN;
        END;
        EXIT(TCardContainer."No.");
    end;

    [Scope('Internal')]
    procedure GetInitialContainerNo(LocationCode: Code[20]): Integer
    var
        TCardContainer: Record "25006870";
    begin
        TCardContainer.RESET;
        TCardContainer.SETRANGE(Enabled, TRUE);
        TCardContainer.SETRANGE(Type, TCardContainer.Type::Booking);
        TCardContainer.SETRANGE(Subtype, TCardContainer.Subtype::Initial);
        TCardContainer.SETRANGE("Location Code", LocationCode);
        IF TCardContainer.FINDFIRST THEN
            EXIT(TCardContainer."No.");
    end;

    [Scope('Internal')]
    procedure GetDefaultLocationCode(): Code[20]
    var
        ServiceSetup: Record "25006120";
        UserProfile: Record "25006067";
        ServiceLocation: Code[20];
        UserProfileMgt: Codeunit "25006002";
    begin
        ServiceSetup.GET;
        IF UserProfile.GET(UserProfileMgt.CurrProfileID) THEN BEGIN
            IF UserProfile.GET(UserProfile."Spec. Service User Profile") THEN BEGIN
                ServiceLocation := UserProfile."Def. Service Location Code";
                IF ServiceLocation = '' THEN
                    ServiceLocation := ServiceSetup."Def. Service Location Code";
            END ELSE BEGIN
                ServiceLocation := UserProfile."Def. Service Location Code";
                IF ServiceLocation = '' THEN
                    ServiceLocation := ServiceSetup."Def. Service Location Code";
            END;
        END ELSE
            ServiceLocation := ServiceSetup."Def. Service Location Code";
        EXIT(ServiceLocation);
    end;

    [Scope('Internal')]
    procedure SetLocationCode(LocationCodeToSet: Code[20])
    begin
        LocationCode := LocationCodeToSet;
    end;

    [Scope('Internal')]
    procedure SetEditMode(EditModeToSet: Boolean)
    begin
        EditMode := EditModeToSet
    end;

    [Scope('Internal')]
    procedure GetContainerColorCodes(ColorName: Option Blue,Green,Orange,Gray,Yellow; var HeaderColorCode: Text[8]; var BodyColorCode: Text[8])
    begin
        CASE ColorName OF
            ColorName::Blue:
                BEGIN
                    HeaderColorCode := '#99c8e9';
                    BodyColorCode := '#cde6f7';
                END;
            ColorName::Green:
                BEGIN
                    HeaderColorCode := '#9cb56e';
                    BodyColorCode := '#c6dd9d';
                END;
            ColorName::Orange:
                BEGIN
                    HeaderColorCode := '#f6a56b';
                    BodyColorCode := '#f7c7a5';
                END;
            ColorName::Gray:
                BEGIN
                    HeaderColorCode := '#9b9b9b';
                    BodyColorCode := '#e6e6e6';
                END;
            ColorName::Yellow:
                BEGIN
                    HeaderColorCode := '';
                    BodyColorCode := '';
                END;
        END;
    end;

    [Scope('Internal')]
    procedure GetContainerDefaultSize(SizeName: Option Small,Medium,Large,Setup) ContainerSize: Integer
    begin
        CASE SizeName OF
            SizeName::Small:
                ContainerSize := 150;
            SizeName::Medium:
                ContainerSize := 330;
            SizeName::Large:
                ContainerSize := 670;
            SizeName::Setup:
                ContainerSize := 0;
        END;
    end;

    [Scope('Internal')]
    procedure CreateNewContainer()
    var
        Container: Record "25006870";
        LineNo: Integer;
    begin
        Container.RESET;
        Container.FINDLAST;
        LineNo := Container."No." + 100;

        Container.INIT;
        Container."No." := LineNo;
        Container."Location Code" := LocationCode;
        Container.Type := Container.Type::Booking;
        Container.Subtype := Container.Subtype::Standard;
        Container.Name := NewContainerTxt;
        Container.Enabled := TRUE;
        Container."Container Size" := Container."Container Size"::Small;
        Container."Container Color" := Container."Container Color"::Gray;
        Container.INSERT;
    end;
}

