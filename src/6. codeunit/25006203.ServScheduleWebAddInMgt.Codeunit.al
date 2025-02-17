codeunit 25006203 "Serv. Schedule Web Add-In Mgt."
{
    // 28.09.2015 EB.P7 #C001
    //   Removed "Transfer Record Count" functionality from "FillItemEntries" function;
    // 
    // 24.08.2014 EDMS P7
    //   * Code Unit created


    trigger OnRun()
    begin
    end;

    var
        ScheduleView: Record "25006282";
        ServScheduleSetup: Record "25006286";
        UserSetup: Record "91";
        CollapsedItem: Record "25006004" temporary;
        ServLaborAllocationEntry: Record "25006271";
        ServiceMgtSetup: Record "25006120";
        ServScheduleMgt: Codeunit "25006201";
        ServScheduleAddInMgt: Codeunit "25006203";
        DocumentMgt: Codeunit "25006000";
        DateTimeMgt: Codeunit "25006012";
        ResourceTimeRegMgt: Codeunit "25006290";
        ScheduleData: BigText;
        StartDT: Decimal;
        EndDT: Decimal;
        Text001: Label 'Data transfer error';
        TextUnknownEvent: Label 'Unknown Event %1';
        ResourceGroup: Code[10];
        UnavailAllocEntryID: Integer;
        AllocationEntryID: Integer;
        AllocationStatus: Option Pending,"In Process","Finish All","Finish Part","On Hold";

    [Scope('Internal')]
    procedure StartAllocation(AllocationNo: Integer; ResourceNo: Code[20]; StartDT: Decimal; EndDT: Decimal)
    var
        SingleInstanceMgt: Codeunit "25006001";
    begin
        CLEAR(ServScheduleMgt);

        IF ServLaborAllocationEntry.GET(AllocationNo) THEN BEGIN
            ResourceTimeRegMgt.AddTimeRegEntries('START', ServLaborAllocationEntry, ServLaborAllocationEntry."Resource No.", WORKDATE, TIME);
        END;

        SingleInstanceMgt.SetCurrAllocation(AllocationNo);
        ServScheduleMgt.StartEndAllocation(AllocationStatus::"In Process");
    end;

    [Scope('Internal')]
    procedure StartWorkTime(ResourceNo: Code[20]; StartDT: Decimal; EndDT: Decimal)
    var
        ServiceScheduleMgt: Codeunit "25006201";
    begin
        CLEAR(ServiceScheduleMgt);
        ServiceScheduleMgt.StartEndWorktime(ResourceNo, 0);
    end;

    [Scope('Internal')]
    procedure EndAllocation(AllocationNo: Integer; ResourceNo: Code[20]; StartDT: Decimal; EndDT: Decimal)
    var
        SingleInstanceMgt: Codeunit "25006001";
    begin
        CLEAR(ServScheduleMgt);

        IF ServLaborAllocationEntry.GET(AllocationNo) THEN BEGIN
            ResourceTimeRegMgt.AddTimeRegEntries('COMPLETE', ServLaborAllocationEntry, ServLaborAllocationEntry."Resource No.", WORKDATE, TIME);
        END;

        SingleInstanceMgt.SetCurrAllocation(AllocationNo);
        ServScheduleMgt.StartEndAllocation(AllocationStatus::"Finish All");
    end;

    [Scope('Internal')]
    procedure EndWorkTime(ResourceNo: Code[20]; StartDT: Decimal; EndDT: Decimal)
    var
        ServiceScheduleMgt: Codeunit "25006201";
    begin
        CLEAR(ServiceScheduleMgt);
        ServiceScheduleMgt.StartEndWorktime(ResourceNo, 1);
    end;

    [Scope('Internal')]
    procedure HoldAllocation(AllocationNo: Integer; ResourceNo: Code[20]; StartDT: Decimal; EndDT: Decimal)
    var
        SingleInstanceMgt: Codeunit "25006001";
    begin
        CLEAR(ServScheduleMgt);

        IF ServLaborAllocationEntry.GET(AllocationNo) THEN BEGIN
            ResourceTimeRegMgt.AddTimeRegEntries('ONHOLD', ServLaborAllocationEntry, ServLaborAllocationEntry."Resource No.", WORKDATE, TIME);
        END;

        SingleInstanceMgt.SetCurrAllocation(AllocationNo);
        ServScheduleMgt.StartEndAllocation(AllocationStatus::"On Hold");
    end;

    [Scope('Internal')]
    procedure BreakAllocation(AllocationNo: Integer; ResourceNo: Code[20]; StartDT: Decimal; EndDT: Decimal)
    var
        SingleInstanceMgt: Codeunit "25006001";
    begin
        CLEAR(ServScheduleMgt);

        IF ServLaborAllocationEntry.GET(AllocationNo) THEN BEGIN
            ResourceTimeRegMgt.AddTimeRegEntries('COMPLETE', ServLaborAllocationEntry, ServLaborAllocationEntry."Resource No.", WORKDATE, TIME);
        END;

        SingleInstanceMgt.SetCurrAllocation(AllocationNo);
        ServScheduleMgt.BreakAllocation;
    end;

    [Scope('Internal')]
    procedure ProcessAllocation(EventType: Integer; NewResNo: Code[20]; NewStartDT: Decimal; NewEndDT: Decimal)
    var
        QtyToAllocate: Decimal;
        SplitTracking: Integer;
        Text001: Label 'Standard Event,Service Line,Service Header';
        Diag: Dialog;
        Text002: Label 'Select allocation type';
    begin
        CASE EventType OF
            1:
                BEGIN //Standard Event
                    ServScheduleMgt.AllocateStandardEvent(NewResNo, NewStartDT, NewEndDT);
                END;
            2:
                BEGIN //Service Line
                    ServScheduleMgt.AllocateServiceLines(NewResNo, NewStartDT, NewEndDT);
                END;
            3:
                BEGIN //Service Header
                    ServScheduleMgt.AllocateServiceOrder(NewResNo, NewStartDT, NewEndDT);
                END;
        END;
    end;

    [Scope('Internal')]
    procedure ProcessReallocation(EntryNo: Integer; NewResNo: Code[20]; NewStartDT: Decimal; NewEndDT: Decimal)
    var
        LaborAllocEntry: Record "25006271";
        QtyToAllocate: Decimal;
        SplitTracking: Integer;
        CurrItemID: Code[100];
        CurrResGroupCode: Code[20];
        SingleInstanceMgt: Codeunit "25006001";
    begin
        SingleInstanceMgt.SetCurrAllocation(EntryNo);

        CurrItemID := NewResNo;
        DecodeItemID(CurrItemID, CurrResGroupCode, NewResNo);
        IF NewResNo = '' THEN
            NewResNo := CurrItemID;
        IF ServScheduleMgt.AllocationChanged(EntryNo, NewResNo, NewStartDT, NewEndDT) THEN BEGIN
            //QtyToAllocate := ROUND((NewEndDT - NewStartDT)/3.6,0.1);
            LaborAllocEntry.GET(EntryNo);

            IF (ServScheduleMgt.IsDateTimeEqualDateTime(NewStartDT, LaborAllocEntry."Start Date-Time") OR
                  ServScheduleMgt.IsDateTimeEqualDateTime(NewEndDT, LaborAllocEntry."End Date-Time")) THEN BEGIN
                NewEndDT := ServScheduleMgt.CalcEndDTOnlyWorktime(NewStartDT, NewEndDT, NewResNo);
                QtyToAllocate := ServScheduleMgt.CalcHourDifference(NewStartDT, NewEndDT);
            END ELSE BEGIN
                // that means moving so length should be left the same
                QtyToAllocate := ServScheduleMgt.CalcHourDifference(LaborAllocEntry."Start Date-Time", LaborAllocEntry."End Date-Time");
            END;
            IF QtyToAllocate <= 0 THEN
                // ROUND by 20 sec - is taken from C25006201.AllocationChanged
                QtyToAllocate := ROUND((NewEndDT - NewStartDT) / 3.6, 0.01, '>');

            SplitTracking := 0;
            ServScheduleMgt.ProcessMovement(EntryNo, NewResNo, NewStartDT, QtyToAllocate, SplitTracking, LaborAllocEntry.Status, 300, LaborAllocEntry.Travel);
        END ELSE BEGIN
            ServScheduleMgt.MoveAllocation(EntryNo, NewResNo, NewStartDT);
        END;
    end;

    [Scope('Internal')]
    procedure ProcessCommands(Index: Integer; EntryNo: Integer; ResNo: Code[20]; CommStartDT: Decimal; CommEndDT: Decimal)
    var
        QtyToAllocate: Decimal;
        SplitTracking: Integer;
        Text001: Label 'Standard Event,Service Line,Service Header';
        Diag: Dialog;
        Text002: Label 'Select allocation type';
    begin
        CASE Index OF
            1020:
                BEGIN //Lookup
                    ServScheduleMgt.LookupAllocationRTC(EntryNo);
                END;
            1220:
                BEGIN  //Deallocate
                    ServScheduleMgt.Deallocate(EntryNo);
                END;
            1230:
                BEGIN  //Change
                    ProcessReallocation(EntryNo, ResNo, CommStartDT, CommEndDT);
                END;
            1340:
                BEGIN  //Set Pos - Used For Search
                       //Data.GETSUBTEXT(Str, 1, 1024);
                       //CurrItemID := SELECTSTR(2,Str);
                       //Direction := Direction::Down;
                       //FillTextData(ScheduleData,Direction,CurrItemID,TRUE);
                END;
            2010:
                BEGIN //Start Allocation
                    IF EntryNo <> 0 THEN
                        StartAllocation(
                          EntryNo, //Entry No.
                          ResNo, //Resource No.
                          CommStartDT, //Start DT as decimal
                          CommEndDT) //End DT as decimal
                    ELSE
                        StartWorkTime(
                          ResNo, //Resource No.
                          CommStartDT, //Start DT as decimal
                          CommEndDT); //End DT as decimal
                END;
            2020:
                BEGIN //End Allocation
                    IF EntryNo <> 0 THEN
                        EndAllocation(
                          EntryNo, //Entry No.
                          ResNo, //Resource No.
                          CommStartDT, //Start DT as decimal
                          CommEndDT) //End DT as decimal
                    ELSE
                        EndWorkTime(
                          ResNo, //Resource No.
                          CommStartDT, //Start DT as decimal
                          CommEndDT); //End DT as decimal
                END;
            2130:
                BEGIN //Hold Allocation
                    IF EntryNo <> 0 THEN
                        HoldAllocation(
                          EntryNo, //Entry No.
                          ResNo, //Resource No.
                          CommStartDT, //Start DT as decimal
                          CommEndDT); //End DT as decimal
                END;
            3000:
                BEGIN //Break Allocation
                    IF EntryNo <> 0 THEN
                        BreakAllocation(
                          EntryNo, //Entry No.
                          ResNo, //Resource No.
                          CommStartDT, //Start DT as decimal
                          CommEndDT); //End DT as decimal
                END;
            1210:
                BEGIN //Allocate
                    CASE DIALOG.STRMENU(Text001, 1, Text002) OF
                        1:
                            BEGIN //Standard Event
                                ServScheduleMgt.AllocateStandardEvent(ResNo, CommStartDT, CommEndDT);
                            END;
                        2:
                            BEGIN //Service Line
                                ServScheduleMgt.AllocateServiceLines(ResNo, CommStartDT, CommEndDT);
                            END;
                        3:
                            BEGIN //Service Header
                                ServScheduleMgt.AllocateServiceOrder(ResNo, CommStartDT, CommEndDT);
                            END;
                    END;
                END;
            1240:
                BEGIN //New Service Order
                    ServScheduleMgt.AllocateNewVisitOrder(ResNo, CommStartDT, CommEndDT);
                END;
            1241:
                BEGIN //Allocate with create quote - fast way
                    ServScheduleMgt.AllocateNewVisitQuote(ResNo, CommStartDT, CommEndDT);
                END;
            2015:
                BEGIN  // Cancel Start Allocation
                    CancelStartAllocation(EntryNo, ResNo, CommStartDT, CommEndDT, TRUE);
                END;
        END;
    end;

    [Scope('Internal')]
    procedure ProcessAllocationEdit(EntryNo: Integer; NewResNo: Code[20]; NewStartDT: Decimal; NewEndDT: Decimal)
    begin
        //Not used
        ServScheduleMgt.MoveAllocation(EntryNo, NewResNo, NewStartDT);
    end;

    [Scope('Internal')]
    procedure FillTextData(var ScheduleData: BigText; Direction: Option Down,Up; CurrItemID: Code[100]; PositionCurr: Boolean)
    var
        outStream: OutStream;
        inStream: InStream;
        TempBlob: Record "99008535" temporary;
        XmlPort1: XMLport "25006200";
        ScheduleCaption: Record "25006287" temporary;
        ScheduleItem: Record "25006288" temporary;
        ScheduleAllocation: Record "25006289" temporary;
        ScheduleTimeRegEntry: Record "25006290" temporary;
        TimeGridItemTmp: Record "25006273" temporary;
        BigTextTmp: BigText;
        StreamReader: DotNet StreamReader;
    begin
        //Main data export procedure

        ServScheduleSetup.GET;
        XmlPort1.SetParam(StartDT, EndDT, ServScheduleSetup."Refresh Interval (ms)", ServScheduleSetup."Allocation Time Step (Minutes)");

        FillCaptionEntries(ScheduleCaption);
        FillItemEntries(ScheduleItem, Direction, CurrItemID, PositionCurr);
        FillAllocationEntries(ScheduleItem, ScheduleAllocation, StartDT, EndDT);
        FillTimeGridItem(TimeGridItemTmp, StartDT, EndDT);
        FillTimeRegEntries(ScheduleTimeRegEntry, ScheduleAllocation);


        XmlPort1.SetCaptions(ScheduleCaption);
        XmlPort1.SetItems(ScheduleItem);
        XmlPort1.SetItemAllocations(ScheduleAllocation);
        XmlPort1.SetTimeGrid(TimeGridItemTmp);
        XmlPort1.SetTimeRegEntry(ScheduleTimeRegEntry);

        TempBlob.INIT;
        TempBlob.INSERT;  //27.06.2013 EDMS P8
        TempBlob.Blob.CREATEOUTSTREAM(outStream);
        XmlPort1.SETDESTINATION(outStream);
        IF XmlPort1.EXPORT THEN BEGIN
            TempBlob.CALCFIELDS(Blob);
            TempBlob.Blob.CREATEINSTREAM(inStream);
            CLEAR(ScheduleData);
            CLEAR(BigTextTmp);

            //BigTextTmp.READ(inStream); that is old way but source code need to store for history
            //UTF8ToHTML(BigTextTmp, ScheduleData);
            StreamReader := StreamReader.StreamReader(inStream, TRUE);
            ScheduleData.ADDTEXT(StreamReader.ReadToEnd());

            LogBigText(ScheduleData); //Creates a copy of transmitten XML data
        END
        ELSE
            ERROR(Text001);
    end;

    [Scope('Internal')]
    procedure DecodeItemID(ItemID: Code[100]; var ResGroupCode: Code[20]; var ResCode: Code[20])
    var
        Pos: Integer;
    begin
        //Extracts Group Code and Resource No. out of ItemID

        ResGroupCode := '';
        ResCode := '';
        Pos := STRPOS(ItemID, '/'); //0..1 separators are expected
        IF Pos = 0 THEN
            ResGroupCode := ItemID
        ELSE BEGIN
            ResGroupCode := COPYSTR(ItemID, 1, Pos - 1);
            ResCode := COPYSTR(ItemID, Pos + 1, STRLEN(ItemID) - Pos);
        END;
    end;

    [Scope('Internal')]
    procedure FillCaptionEntries(var ScheduleCaption: Record "25006287")
    var
        Text1010: Label 'Refresh';
        Text1020: Label 'Lookup';
        Text1210: Label 'Allocate';
        Text1211: Label 'New Service Order';
        Text1212: Label 'New Service Quote';
        Text1220: Label 'Deallocate';
        Text1230: Label 'Change';
        Text2010: Label 'Start';
        Text2020: Label 'End';
        Text2110: Label 'Start Allocation';
        Text2120: Label 'Finish Allocation';
        Text2130: Label 'Hold Allocation';
        Text2140: Label 'Break';
        Text3000: Label 'Setup Based Function';
        Text3001: Label 'Setup Based Function';
        Text3002: Label 'Setup Based Function';
        Text3003: Label 'Setup Based Function';
        Text99001: Label 'Licenced To:';
        Text99010: Label '[b]Date:---';
        Text99011: Label 'From:---';
        Text99012: Label 'To:---';
        Text2015: Label 'Cancel Start';
    begin
        //Fills item entries to the buffer
        ScheduleCaption.RESET;
        ScheduleCaption.DELETEALL;
        ScheduleCaption.ID := 1010;
        ScheduleCaption.Caption := Text1010;
        ScheduleCaption.SequenceNo := 7;
        ScheduleCaption.VALIDATE(GroupingCode, '');
        ScheduleCaption.INSERT;
        ScheduleCaption.ID := 1020;
        ScheduleCaption.Caption := Text1020;
        ScheduleCaption.SequenceNo := 1;
        ScheduleCaption.VALIDATE(GroupingCode, 'ALLOC');
        ScheduleCaption.INSERT;
        ScheduleCaption.ID := 1210;
        ScheduleCaption.Caption := Text1210;
        ScheduleCaption.SequenceNo := 4;
        ScheduleCaption.VALIDATE(GroupingCode, 'ENABLED');
        ScheduleCaption.INSERT;
        ScheduleCaption.ID := 1241;
        ScheduleCaption.Caption := Text1212;
        ScheduleCaption.SequenceNo := 8;
        ScheduleCaption.VALIDATE(GroupingCode, 'ENABLED');
        ScheduleCaption.INSERT;
        ScheduleCaption.ID := 1240;
        ScheduleCaption.Caption := Text1211;
        ScheduleCaption.SequenceNo := 9;
        ScheduleCaption.VALIDATE(GroupingCode, 'ENABLED');
        ScheduleCaption.INSERT;
        ScheduleCaption.ID := 1220;
        ScheduleCaption.Caption := Text1220;
        ScheduleCaption.SequenceNo := 6;
        ScheduleCaption.VALIDATE(GroupingCode, 'ALLOC');
        ScheduleCaption.INSERT;
        ScheduleCaption.ID := 1230;
        ScheduleCaption.Caption := Text1230;
        ScheduleCaption.SequenceNo := 5;
        ScheduleCaption.VALIDATE(GroupingCode, 'ALLOC');
        ScheduleCaption.INSERT;
        ScheduleCaption.ID := 2010;
        ScheduleCaption.Caption := Text2010;
        ScheduleCaption.SequenceNo := 2;
        ScheduleCaption.VALIDATE(GroupingCode, 'ITEM');
        ScheduleCaption.INSERT;
        ScheduleCaption.ID := 2010;
        ScheduleCaption.Caption := Text2010;
        ScheduleCaption.SequenceNo := 2;
        ScheduleCaption.VALIDATE(GroupingCode, 'ALLOC');
        ScheduleCaption.INSERT;
        ScheduleCaption.ID := 2020;
        ScheduleCaption.Caption := Text2020;
        ScheduleCaption.SequenceNo := 3;
        ScheduleCaption.VALIDATE(GroupingCode, 'ITEM');
        ScheduleCaption.INSERT;
        ScheduleCaption.ID := 2015;
        ScheduleCaption.Caption := Text2015;
        ScheduleCaption.SequenceNo := 3;
        ScheduleCaption.VALIDATE(GroupingCode, 'ALLOC');
        ScheduleCaption.INSERT;   // 16.05.2014 Elva Baltic P21 #S0101 MMG7.00
        ScheduleCaption.ID := 2020;
        ScheduleCaption.Caption := Text2020;
        ScheduleCaption.SequenceNo := 4;
        ScheduleCaption.VALIDATE(GroupingCode, 'ALLOC');
        ScheduleCaption.INSERT;   // 16.05.2014 Elva Baltic P21 #S0101 MMG7.00  Changed Seq. 3 <- 4
        ScheduleCaption.ID := 2130;
        ScheduleCaption.Caption := Text2130;
        ScheduleCaption.SequenceNo := 91;
        ScheduleCaption.VALIDATE(GroupingCode, 'ALLOC');
        ScheduleCaption.INSERT;
        ScheduleCaption.ID := 3000;
        ScheduleCaption.Caption := Text2140;
        ScheduleCaption.SequenceNo := 92;
        ScheduleCaption.VALIDATE(GroupingCode, 'ALLOC');
        ScheduleCaption.INSERT;

        //captions of tooltip
        ScheduleCaption.ID := 99010;
        ScheduleCaption.Caption := Text99010;
        ScheduleCaption.SequenceNo := 1;
        ScheduleCaption.INSERT;
        ScheduleCaption.ID := 99011;
        ScheduleCaption.Caption := Text99011;
        ScheduleCaption.SequenceNo := 2;
        ScheduleCaption.INSERT;
        ScheduleCaption.ID := 99012;
        ScheduleCaption.Caption := Text99012;
        ScheduleCaption.SequenceNo := 3;
        ScheduleCaption.INSERT;
    end;

    [Scope('Internal')]
    procedure FillItemEntries(var ScheduleItem: Record "25006288"; Direction: Option Down,Up; CurrItemID: Code[100]; PositionCurrent: Boolean)
    var
        ResGroupSpec: Record "25006275";
        ResGroupSpec2: Record "25006275";
        NewEntryNo: Integer;
        ResColor: Integer;
        DocumentMgt: Codeunit "25006000";
        ResGroupSet: Boolean;
        ResSet: Boolean;
        Steps: Integer;
        ItemIDCounter: Integer;
        ColorR: Integer;
        ColorG: Integer;
        ColorB: Integer;
        Sequence: Integer;
        LastGroupCode: Code[20];
        TransfRecordCount: Integer;
        PosSign: Decimal;
        PosFactor: Decimal;
        Step: Integer;
        ItemID: Code[100];
        Current: Boolean;
        CurrResGroupCode: Code[20];
        CurrResCode: Code[20];
        GroupItemID: Code[100];
        TotalItemCount: Integer;
        ItemPos: Integer;
        ItemPosCurr: Integer;
        ResourceTmp: Record "156" temporary;
    begin
        //Fills item entries to the buffer

        ScheduleItem.RESET;
        ScheduleItem.DELETEALL;
        ServScheduleSetup.GET;

        ItemIDCounter := 0;
        IF ((CurrItemID = '') AND (ResourceGroup = '')) THEN
            EXIT;
        DecodeItemID(CurrItemID, CurrResGroupCode, CurrResCode);
        IF (CurrResGroupCode = '') THEN
            CurrResGroupCode := ResourceGroup;

        PosSign := 1;
        PosFactor := 0;

        ResGroupSpec.RESET;
        //22.03.2014 Elva Baltic P1 #RX MMG7.00 >>
        ResGroupSpec.SETCURRENTKEY(Description);
        //22.03.2014 Elva Baltic P1 #RX MMG7.00 <<
        ResGroupSpec.ASCENDING(Direction = Direction::Down);
        //IF ResourceGroup <> '' THEN
        ResGroupSpec.SETRANGE("Group Code", ResourceGroup);

        IF CurrResCode <> '' THEN
            ResGroupSpec.SETRANGE("Resource No.", CurrResCode);

        IF Direction = Direction::Down THEN BEGIN
            IF NOT ResGroupSpec.FINDFIRST THEN
                EXIT;
        END ELSE BEGIN
            IF NOT ResGroupSpec.FINDLAST THEN
                EXIT;
        END;

        ResGroupSpec.SETRANGE("Resource No.");

        TotalItemCount := ResGroupSpec.COUNT;
        ItemPos := ItemIDPosition(CurrItemID);


        IF ItemPos = 0 THEN
            ItemPos := 1;

        // for now is done to see Resource once !
        ResourceTmp.RESET;
        ResourceTmp.DELETEALL;
        REPEAT
            IF NOT ResourceTmp.GET(ResGroupSpec."Resource No.") THEN BEGIN
                ResourceTmp."No." := ResGroupSpec."Resource No.";
                ResourceTmp.INSERT;


                GroupItemID := GenerateItemID(ResGroupSpec."Group Code", '');
                ItemIDCounter += 1;
                //New Item Entry >>
                ServScheduleMgt.SetResourceColor(ResGroupSpec."Resource No.", ResColor);
                ColorR := DocumentMgt.Color2Red(ResColor);
                ColorG := DocumentMgt.Color2Green(ResColor);
                ColorB := DocumentMgt.Color2Blue(ResColor);

                ItemID := GenerateItemID(ResGroupSpec."Group Code", ResGroupSpec."Resource No.");

                Current := FALSE;
                IF PositionCurrent AND (ItemID = CurrItemID) THEN
                    Current := TRUE;


                AddItemEntry(ScheduleItem,
                             ItemID, //Item ID
                             ResGroupSpec."Resource No.", //Item No.
                             ResGroupSpec.Description,
                             PosFactor + PosSign * ItemIDCounter, //Sequence
                             1, //Level
                             Current, //Current
                             FALSE, //Parent
                             ColorR, //ColorR
                             ColorG, //ColorG
                             0, //ColorB
                             ItemPos + PosSign * (ItemIDCounter - 1), //Position
                             TotalItemCount);//Total Count
            END;
        UNTIL ResGroupSpec.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure FillAllocationEntries(var ScheduleItem: Record "25006288"; var ScheduleAllocation: Record "25006289"; StartDT: Decimal; EndDT: Decimal)
    begin
        //Fills allocation entries

        UnavailAllocEntryID := 0;
        AllocationEntryID := 0;

        ScheduleAllocation.RESET;
        ScheduleAllocation.DELETEALL;
        ScheduleItem.RESET;
        IF ScheduleItem.FINDFIRST THEN
            REPEAT
                IF NOT ScheduleItem.Parent THEN
                    FillItemAllocations(ScheduleAllocation, ScheduleItem.ItemNo, ScheduleItem.ItemID, StartDT, EndDT)
            UNTIL ScheduleItem.NEXT = 0;
    end;

    [Scope('Internal')]
    procedure FillItemAllocations(var ScheduleAllocation: Record "25006289"; ResourceNo: Code[20]; ItemID: Code[200]; StartingDateTimeDec: Decimal; EndingDateTimeDec: Decimal)
    var
        AllocEntryReal: Record "25006271";
        ResGroupSpec: Record "25006275";
        DateRec: Record "2000000007";
        UnavailAllocEntry: Record "25006271" temporary;
        ForeColor: Integer;
        BackColor: Integer;
    begin
        ServiceMgtSetup.GET;
        //Fills item's allocations to the buffer

        //Step 1: Filling real allocations
        AllocEntryReal.RESET;
        AllocEntryReal.SETCURRENTKEY("Resource No.", "Start Date-Time", "End Date-Time");
        AllocEntryReal.SETFILTER("Resource No.", ResourceNo);
        AllocEntryReal.SETFILTER("Start Date-Time", '<=%1', EndingDateTimeDec);
        AllocEntryReal.SETFILTER("End Date-Time", '>%1', StartingDateTimeDec);
        AllocEntryReal.SETFILTER("Source ID", '<>%1', ServiceMgtSetup."Default Idle Event");
        IF AllocEntryReal.FINDFIRST THEN
            REPEAT
                AllocationEntryID += 1;

                ScheduleAllocation.INIT;
                ScheduleAllocation.EntryNo := AllocationEntryID;
                ScheduleAllocation.OriginalEntryNo := AllocEntryReal."Entry No.";
                ScheduleAllocation.ItemID := ItemID;
                ScheduleAllocation.ItemNo := AllocEntryReal."Resource No.";
                ScheduleAllocation.Text := ServScheduleMgt.GetAllocRecDescr(AllocEntryReal);
                ScheduleAllocation.StartDT := AllocEntryReal."Start Date-Time";
                ScheduleAllocation.EndDT := AllocEntryReal."End Date-Time";
                ScheduleAllocation.DisplayStartDT := AllocEntryReal."Start Date-Time";
                ScheduleAllocation.DisplayEndDT := AllocEntryReal."End Date-Time";

                //Setting colors >>
                AllocEntryReal."Allocation Status" := AllocEntryReal."Allocation Status"::Allocation;
                ServScheduleMgt.SetCellFormatRTC(AllocEntryReal, ForeColor, BackColor);
                ScheduleAllocation.BackColorR := DocumentMgt.Color2Red(BackColor);
                ScheduleAllocation.BackColorG := DocumentMgt.Color2Green(BackColor);
                ScheduleAllocation.BackColorB := DocumentMgt.Color2Blue(BackColor);

                ScheduleAllocation.ForeColorR := DocumentMgt.Color2Red(ForeColor);
                ScheduleAllocation.ForeColorG := DocumentMgt.Color2Green(ForeColor);
                ScheduleAllocation.ForeColorB := DocumentMgt.Color2Blue(ForeColor);
                //Setting colors <<

                ScheduleAllocation.Editable := TRUE;
                ScheduleAllocation.AllocType := ScheduleAllocation.AllocType::Normal;
                ScheduleAllocation.GroupingCode := 'ALLOC';
                ScheduleAllocation.Travel := AllocEntryReal.Travel;
                ScheduleAllocation.INSERT;
            UNTIL AllocEntryReal.NEXT = 0;

        //Step 2: Filling completed idle allocations
        AllocEntryReal.RESET;
        AllocEntryReal.SETCURRENTKEY("Resource No.", "Start Date-Time", "End Date-Time");
        AllocEntryReal.SETFILTER("Resource No.", ResourceNo);
        AllocEntryReal.SETFILTER("Start Date-Time", '<=%1', EndingDateTimeDec);
        AllocEntryReal.SETFILTER("End Date-Time", '>%1', StartingDateTimeDec);
        AllocEntryReal.SETRANGE("Source Type", AllocEntryReal."Source Type"::"Standard Event");
        AllocEntryReal.SETRANGE("Source ID", ServiceMgtSetup."Default Idle Event");
        AllocEntryReal.SETRANGE(AllocEntryReal.Status, AllocEntryReal.Status::Finished);

        IF AllocEntryReal.FINDFIRST THEN
            REPEAT
                AllocationEntryID += 1;

                ScheduleAllocation.INIT;
                ScheduleAllocation.EntryNo := AllocationEntryID;
                ScheduleAllocation.OriginalEntryNo := AllocEntryReal."Entry No.";
                ScheduleAllocation.ItemID := ItemID;
                ScheduleAllocation.ItemNo := AllocEntryReal."Resource No.";
                ScheduleAllocation.Text := ServScheduleMgt.GetAllocRecDescr(AllocEntryReal);
                ScheduleAllocation.StartDT := AllocEntryReal."Start Date-Time";
                ScheduleAllocation.EndDT := AllocEntryReal."End Date-Time";
                ScheduleAllocation.DisplayStartDT := AllocEntryReal."Start Date-Time";
                ScheduleAllocation.DisplayEndDT := AllocEntryReal."End Date-Time";

                //Setting colors >>
                AllocEntryReal."Allocation Status" := AllocEntryReal."Allocation Status"::Allocation;
                ServScheduleMgt.SetCellFormatRTC(AllocEntryReal, ForeColor, BackColor);
                ScheduleAllocation.BackColorR := DocumentMgt.Color2Red(BackColor);
                ScheduleAllocation.BackColorG := DocumentMgt.Color2Green(BackColor);
                ScheduleAllocation.BackColorB := DocumentMgt.Color2Blue(BackColor);

                ScheduleAllocation.ForeColorR := DocumentMgt.Color2Red(ForeColor);
                ScheduleAllocation.ForeColorG := DocumentMgt.Color2Green(ForeColor);
                ScheduleAllocation.ForeColorB := DocumentMgt.Color2Blue(ForeColor);
                //Setting colors <<

                ScheduleAllocation.Editable := TRUE;
                ScheduleAllocation.AllocType := ScheduleAllocation.AllocType::Normal;
                ScheduleAllocation.GroupingCode := 'ALLOC';

                ScheduleAllocation.INSERT;
            UNTIL AllocEntryReal.NEXT = 0;

        //Step 3: Filling generated allocations which will show unavailable time
        IF ServScheduleSetup."Show Unavailable Time" THEN BEGIN
            DateRec.RESET;
            DateRec.SETRANGE("Period Type", DateRec."Period Type"::Date);
            DateRec.SETRANGE("Period Start", DateTimeMgt.Datetime2Date(StartingDateTimeDec), DateTimeMgt.Datetime2Date(EndingDateTimeDec));
            IF DateRec.FINDFIRST THEN
                REPEAT
                    ServScheduleMgt.FillUnavailableTimeEntries(UnavailAllocEntry, ResourceNo,
                                                                  DateRec."Period Start");
                UNTIL DateRec.NEXT = 0;


            IF UnavailAllocEntry.FINDFIRST THEN
                REPEAT
                    UnavailAllocEntryID -= 1;

                    ScheduleAllocation.INIT;
                    ScheduleAllocation.EntryNo := UnavailAllocEntryID;

                    ScheduleAllocation.ItemID := ItemID;
                    ScheduleAllocation.ItemNo := UnavailAllocEntry."Resource No.";
                    ScheduleAllocation.Text := ''; //Appears with no text
                    ScheduleAllocation.StartDT := UnavailAllocEntry."Start Date-Time";
                    ScheduleAllocation.EndDT := UnavailAllocEntry."End Date-Time";
                    ScheduleAllocation.DisplayStartDT := UnavailAllocEntry."Start Date-Time";
                    ScheduleAllocation.DisplayEndDT := UnavailAllocEntry."End Date-Time";

                    //Setting colors >>
                    UnavailAllocEntry."Allocation Status" := UnavailAllocEntry."Allocation Status"::Unavailability;
                    ServScheduleMgt.SetCellFormatRTC(UnavailAllocEntry, ForeColor, BackColor);
                    ScheduleAllocation.BackColorR := DocumentMgt.Color2Red(BackColor);
                    ScheduleAllocation.BackColorG := DocumentMgt.Color2Green(BackColor);
                    ScheduleAllocation.BackColorB := DocumentMgt.Color2Blue(BackColor);

                    ScheduleAllocation.ForeColorR := DocumentMgt.Color2Red(ForeColor);
                    ScheduleAllocation.ForeColorG := DocumentMgt.Color2Green(ForeColor);
                    ScheduleAllocation.ForeColorB := DocumentMgt.Color2Blue(ForeColor);
                    //Setting colors <<

                    ScheduleAllocation.Editable := TRUE;
                    ScheduleAllocation.AllocType := ScheduleAllocation.AllocType::Background;
                    ScheduleAllocation.GroupingCode := 'DISABLED';

                    ScheduleAllocation.INSERT;

                UNTIL UnavailAllocEntry.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure FillTimeGridItem(var TimeGridItemPar: Record "25006273" temporary; StartDT: Decimal; EndDT: Decimal)
    var
        TimeGridItemLoc: Record "25006273";
    begin
        //Fills Time Grid Items

        TimeGridItemPar.RESET;
        TimeGridItemPar.DELETEALL;
        IF ScheduleView.Code <> '' THEN BEGIN
            TimeGridItemLoc.SETRANGE("Grid Code", ScheduleView."Time Grid Code");
            IF TimeGridItemLoc.FINDFIRST THEN
                REPEAT
                    TimeGridItemPar := TimeGridItemLoc;
                    TimeGridItemPar.INSERT;
                UNTIL TimeGridItemLoc.NEXT = 0;
        END;
    end;

    [Scope('Internal')]
    procedure AddItemEntry(var ScheduleItem: Record "25006288"; ItemID: Code[100]; ItemNo: Code[20]; ItemDesc: Text[250]; Sequence: Integer; Level: Integer; Current: Boolean; Parent: Boolean; ColorR: Integer; ColorG: Integer; ColorB: Integer; ItemPosition: Integer; TotalCnt: Integer)
    var
        Collapsed: Boolean;
    begin
        //Adds item item entry to the buffer

        ScheduleItem.INIT;
        ScheduleItem.Sequence := Sequence;
        ScheduleItem.ItemID := ItemID;
        ScheduleItem.ItemNo := ItemNo;
        CASE ServScheduleSetup."Resource Name in Schedule" OF
            ServScheduleSetup."Resource Name in Schedule"::Description:
                ScheduleItem.Description := ItemDesc;
            ServScheduleSetup."Resource Name in Schedule"::"No.&Description":
                ScheduleItem.Description := ItemNo + ', ' + ItemDesc;
            ELSE
                ScheduleItem.Description := ItemNo;
        END;
        ScheduleItem.Level := Level;
        ScheduleItem.Current := Current;
        ScheduleItem.Parent := Parent;

        Collapsed := FALSE;
        IF Parent THEN
            IF IsCollapsed(ItemID) THEN
                Collapsed := TRUE;

        ScheduleItem.Collapsed := Collapsed;

        ScheduleItem.ForeColorR := ColorR;
        ScheduleItem.ForeColorG := ColorG;
        ScheduleItem.ForeColorB := ColorB;
        ScheduleItem.ScrollBarPosition := ItemPosition;
        ScheduleItem.ScrollBarTotalCount := TotalCnt;
        ScheduleItem.GroupingCode := 'ITEM';
        ScheduleItem.INSERT;
    end;

    [Scope('Internal')]
    procedure LogBigText(var TextPar: BigText): Boolean
    var
        LogFileName: Text[1024];
        LogFile: File;
        OutStream: OutStream;
        InStream: InStream;
        TextTmp: Text[1024];
        tempData: Record "99008535" temporary;
        BText: BigText;
        CRLF: Text[2];
        CR: Char;
        LF: Char;
    begin
        // returns either is logged or not
        IF NOT UserSetup.GET(USERID) THEN
            EXIT(FALSE);
        IF UserSetup."Schedule Add-In Log Active" THEN BEGIN
            IF UserSetup."Schedule Add-In Log Path" = '' THEN
                EXIT(FALSE);
            LogFileName := UserSetup."Schedule Add-In Log Path" + 'rtcxmllog.log';

            IF LogFile.OPEN(LogFileName) THEN BEGIN
                LogFile.CREATEINSTREAM(InStream);
                BText.READ(InStream); /// Why in RTC it does not work?
                InStream.READTEXT(TextTmp);
                LogFile.CLOSE;
            END;
            IF NOT LogFile.CREATE(LogFileName) THEN
                EXIT(FALSE);
            LogFile.CREATEOUTSTREAM(OutStream);

            BText.WRITE(OutStream);
            CR := 13;
            CRLF := FORMAT(CR);
            TextTmp := 'Log info at:' + FORMAT(CURRENTDATETIME) + ':';
            OutStream.WRITETEXT(TextTmp);
            OutStream.WRITETEXT(CRLF);
            TextPar.WRITE(OutStream);
            OutStream.WRITETEXT(CRLF);
            LogFile.CLOSE;

        END;
        EXIT(TRUE);
    end;

    [Scope('Internal')]
    procedure LogBigTextToFile(var TextPar: BigText; LogFileName: Text[1024]): Boolean
    var
        LogFile: File;
        OutStream: OutStream;
        InStream: InStream;
        TextTmp: Text[1024];
        tempData: Record "99008535" temporary;
        BText: BigText;
        CRLF: Text[2];
        CR: Char;
        LF: Char;
    begin
        // returns either is logged or not
        IF NOT UserSetup.GET(USERID) THEN
            EXIT(FALSE);

        IF LogFileName = '' THEN
            EXIT(FALSE);

        IF LogFile.OPEN(LogFileName) THEN BEGIN
            LogFile.CREATEINSTREAM(InStream);
            BText.READ(InStream); /// Why in RTC it does not work?
            InStream.READTEXT(TextTmp);
            LogFile.CLOSE;
        END;
        IF NOT LogFile.CREATE(LogFileName) THEN
            EXIT(FALSE);
        LogFile.CREATEOUTSTREAM(OutStream);

        BText.WRITE(OutStream);
        CR := 13;
        CRLF := FORMAT(CR);
        TextTmp := 'Log info at:' + FORMAT(CURRENTDATETIME) + ':';
        OutStream.WRITETEXT(TextTmp);
        OutStream.WRITETEXT(CRLF);
        TextPar.WRITE(OutStream);
        OutStream.WRITETEXT(CRLF);
        LogFile.CLOSE;

        EXIT(TRUE);
    end;

    [Scope('Internal')]
    procedure ItemIDPosition(ItemID: Code[100]): Integer
    var
        GroupCode: Code[20];
        ResNo: Code[20];
        ResGroupSpec: Record "25006275";
        FromGroupCode: Code[20];
        FromResNo: Code[20];
        ToGroupCode: Code[20];
        ToResNo: Code[20];
        Pos: Integer;
    begin
        //Returns Item's possition

        GroupCode := '';
        ResNo := '';
        DecodeItemID(ItemID, GroupCode, ResNo);

        //Getting Start Possition
        ResGroupSpec.RESET;
        IF NOT ResGroupSpec.FINDFIRST THEN
            EXIT(0);
        FromGroupCode := ResGroupSpec."Group Code";
        FromResNo := ResGroupSpec."Resource No.";

        //Getting End Possition
        ResGroupSpec.RESET;
        ResGroupSpec.SETRANGE("Group Code", GroupCode);
        IF ResNo <> '' THEN
            ResGroupSpec.SETRANGE("Resource No.", ResNo);
        IF NOT ResGroupSpec.FINDFIRST THEN
            EXIT(0);
        ToGroupCode := ResGroupSpec."Group Code";
        ToResNo := ResGroupSpec."Resource No.";


        Pos := CountEntries(FromGroupCode, FromResNo, ToGroupCode, ToResNo);
        IF ResNo = '' THEN
            Pos -= 1;
        EXIT(Pos);
    end;

    [Scope('Internal')]
    procedure GenerateItemID(ResGroupCode: Code[20]; ResCode: Code[20]): Code[100]
    begin
        //Creates an ItemID out of Group Code and Resource No.

        IF ResCode = '' THEN
            EXIT(ResGroupCode)
        ELSE
            EXIT(ResGroupCode + '/' + ResCode);
    end;

    [Scope('Internal')]
    procedure IsCollapsed(ItemID: Code[100]): Boolean
    begin
        //Checks if item is collapsed

        CollapsedItem.RESET;
        CollapsedItem.SETCURRENTKEY("Code Field 1");
        CollapsedItem.SETRANGE("Code Field 1", ItemID);
        EXIT(CollapsedItem.FINDFIRST = TRUE);
    end;

    [Scope('Internal')]
    procedure CountEntries(FromGroupCode: Code[20]; FromResNo: Code[20]; ToGroupCode: Code[20]; ToResNo: Code[20]) RecCount: Integer
    var
        ResGroupSpec: Record "25006275";
        ResGroupSpec2: Record "25006275";
    begin
        //Returns the number of items withing a range. Considers collapsed items

        RecCount := 0;

        ResGroupSpec.RESET;
        ResGroupSpec.SETRANGE("Group Code", FromGroupCode);
        ResGroupSpec.SETRANGE("Resource No.", FromResNo);
        IF NOT ResGroupSpec.FINDFIRST THEN
            EXIT;

        ResGroupSpec.SETRANGE("Group Code");
        ResGroupSpec.SETRANGE("Resource No.");

        REPEAT

            //Group Counter >>
            RecCount += 1;

            ResGroupSpec.SETRANGE("Group Code", ResGroupSpec."Group Code");
            ResGroupSpec.FINDLAST;
            ResGroupSpec.SETRANGE("Group Code");
            //Group Counter <<

            //Item Counter >>
            IF NOT IsCollapsed(GenerateItemID(ResGroupSpec."Group Code", '')) THEN BEGIN
                ResGroupSpec2.RESET;
                ResGroupSpec2.SETRANGE("Group Code", ResGroupSpec."Group Code");
                CASE TRUE OF
                    (ResGroupSpec."Group Code" = FromGroupCode) AND (ResGroupSpec."Group Code" = ToGroupCode):
                        ResGroupSpec2.SETFILTER("Resource No.", '%1..%2', FromResNo, ToResNo);
                    (ResGroupSpec."Group Code" = FromGroupCode):
                        ResGroupSpec2.SETFILTER("Resource No.", '%1..', FromResNo);
                    (ResGroupSpec."Group Code" = ToGroupCode):
                        ResGroupSpec2.SETFILTER("Resource No.", '..%1', ToResNo);
                END;
                RecCount += ResGroupSpec2.COUNT;
            END;
        //Item Counter <<
        UNTIL (ResGroupSpec."Group Code" = ToGroupCode) OR (ResGroupSpec.NEXT = 0);
    end;

    [Scope('Internal')]
    procedure SetParameters(StartDT1: Decimal; EndDT1: Decimal; ResourceGroup1: Code[10]; ScheduleViewCode: Code[10])
    begin
        //Sets initial parameters. Gets called from the page where add-in is placed

        StartDT := StartDT1;
        EndDT := EndDT1;
        ResourceGroup := ResourceGroup1;
        IF ScheduleView.GET(ScheduleViewCode) THEN;
    end;

    [Scope('Internal')]
    procedure Refresh(var ScheduleData: BigText)
    begin
        CLEAR(ScheduleData);
        ScheduleData.ADDTEXT(STRSUBSTNO('Command:1010,1,1'), 1);
    end;

    [Scope('Internal')]
    procedure Search(var ScheduleData: BigText)
    var
        SearchPage: Page "25006352";
        ResGroupSpec: Record "25006275";
        Data: BigText;
        CurrItemID: Code[100];
        CurrGroupID: Code[100];
    begin
        //Search procedure

        CLEAR(SearchPage);
        IF SearchPage.RUNMODAL = ACTION::OK THEN BEGIN
            IF SearchPage.TargetResourceNo = '' THEN
                EXIT;
            ResGroupSpec.RESET;
            ResGroupSpec.SETRANGE("Resource No.", SearchPage.TargetResourceNo);
            IF ResGroupSpec.FINDFIRST THEN BEGIN
                CurrItemID := GenerateItemID(ResGroupSpec."Group Code", ResGroupSpec."Resource No.");
                CurrGroupID := GenerateItemID(ResGroupSpec."Group Code", '');
                IF IsCollapsed(CurrGroupID) THEN
                    OnClickTree(CurrGroupID);
                Data.ADDTEXT(',' + GenerateItemID(ResGroupSpec."Group Code", ResGroupSpec."Resource No."));
                //ProcessCommands(1340,Data,ScheduleData)
            END ELSE
                MESSAGE('Cannot find');
        END;
    end;

    [Scope('Internal')]
    procedure OnClickTree(ItemID: Code[100])
    var
        EntryNo: Integer;
    begin
        //Called when clicked on +/- in the tree. Works like a trigger

        CollapsedItem.RESET;
        CollapsedItem.SETCURRENTKEY("Code Field 1");
        CollapsedItem.SETRANGE("Code Field 1", ItemID);
        IF CollapsedItem.FINDFIRST THEN
            CollapsedItem.DELETE
        ELSE BEGIN
            EntryNo := 0;
            CollapsedItem.RESET;
            IF CollapsedItem.FINDLAST THEN
                EntryNo := CollapsedItem."Entry No.";
            EntryNo += 1;
            CollapsedItem.INIT;
            CollapsedItem."Entry No." := EntryNo;
            CollapsedItem."Code Field 1" := ItemID;
            CollapsedItem.INSERT;
        END;
    end;

    [Scope('Internal')]
    procedure CancelStartAllocation(AllocationNo: Integer; ResourceNo: Code[20]; StartDT: Decimal; EndDT: Decimal; ShowDialog: Boolean)
    var
        SingleInstanceMgt: Codeunit "25006001";
    begin
        CLEAR(ServScheduleMgt);

        IF ServLaborAllocationEntry.GET(AllocationNo) THEN BEGIN
            ResourceTimeRegMgt.AddTimeRegEntries('CANCELSTART', ServLaborAllocationEntry, ServLaborAllocationEntry."Resource No.", WORKDATE, TIME);
        END;

        SingleInstanceMgt.SetCurrAllocation(AllocationNo);
        //22.12.2014 Elva Baltic P1 - uncommented>>
        ServScheduleMgt.CancelAllocation(AllocationStatus::Pending, StartDT, ShowDialog); //that is commented at 05.09.2014 - function from EDMS7.10.11
        //22.12.2014 Elva Baltic P1 - uncommented<<
    end;

    [Scope('Internal')]
    procedure FillTimeRegEntries(var ResourceTimeRegEntryTmp: Record "25006290" temporary; var ScheduleAllocation: Record "25006289")
    var
        ResourceTimeRegEntry: Record "25006290";
    begin
        //Fills resource time reg entries

        ResourceTimeRegEntryTmp.RESET;
        ResourceTimeRegEntryTmp.DELETEALL;

        IF ScheduleAllocation.FINDFIRST THEN
            REPEAT
                ResourceTimeRegEntry.RESET;
                ResourceTimeRegEntry.SETRANGE("Worktime Entry", FALSE);
                ResourceTimeRegEntry.SETRANGE(Canceled, FALSE);
                ResourceTimeRegEntry.SETRANGE(Idle, FALSE);
                ResourceTimeRegEntry.SETRANGE("Allocation Entry No.", ScheduleAllocation.OriginalEntryNo);
                IF ResourceTimeRegEntry.FINDFIRST THEN
                    REPEAT
                        //ResourceTimeRegEntryTmp.INIT;
                        ResourceTimeRegEntryTmp := ResourceTimeRegEntry;
                    //ResourceTimeRegEntryTmp.INSERT;
                    UNTIL ResourceTimeRegEntry.NEXT = 0;
            UNTIL ScheduleAllocation.NEXT = 0;
    end;
}

