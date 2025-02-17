pageextension 50119 pageextension50119 extends "Req. Worksheet"
{
    // 31.05.2016 EB.P30 EDMS T036
    //   Field "Transfer-from Code" Changed to editable
    // 
    // 16.03.2016 EB.P7 Branch Profile Setup
    //   Modified OnOpenPage(), Usert Profile Setup to Branch Profile Setup
    // 
    // 09.06.2014 Elva Baltic P1 #F0001 EDMS7.10
    //   * Added:
    //     "Ordering Price Type Code"
    // 
    // 08.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Changed ReservedFor SourceExpr:
    //     CreateForText to CreateForText2
    //   Added code to:
    //     OnOpenPage
    //     OnInsertRecord
    // 
    // 31.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added fields:
    //     ReservedFor
    //     ReservationCustomerNo
    //     ReservationCustomerName
    //     ReservationVIN
    //     ReservationDealType
    //     ReservationOrderingPriceType
    //   Added code to:
    //     OnAfterGetRecord
    // 
    // 06.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added field:
    //     "Reserved Quantity"
    // 
    // 04.11.2013 EDMS P8
    //   * Added factbox <Item Line Factbox>
    // 
    // 18.01.2013 EDMS P8
    //   * Added Function: Get Service Order

    //Unsupported feature: Property Insertion (Name) on ""Req. Worksheet"(Page 291)".

    Editable = true;
    layout
    {

        //Unsupported feature: Property Modification (TableRelation) on "Control 300".


        //Unsupported feature: Property Modification (TableRelation) on "Control 302".


        //Unsupported feature: Property Modification (TableRelation) on "Control 304".


        //Unsupported feature: Property Modification (TableRelation) on "Control 306".


        //Unsupported feature: Property Modification (TableRelation) on "Control 308".


        //Unsupported feature: Property Modification (TableRelation) on "Control 310".


        //Unsupported feature: Property Modification (Level) on "Control 13".


        //Unsupported feature: Property Modification (ControlType) on "Control 13".


        //Unsupported feature: Property Insertion (SubPageLink) on "Control 13".


        //Unsupported feature: Property Insertion (PagePartID) on "Control 13".


        //Unsupported feature: Property Insertion (PartType) on "Control 13".

        addafter("Control 36")
        {
            field("Inventory Posting Group"; "Inventory Posting Group")
            {
            }
            field("Supply From"; Rec."Supply From")
            {
                Visible = false;
            }
        }
        addafter("Control 94")
        {
            field("Purchasing Code"; Rec."Purchasing Code")
            {
            }
            field("Blanket Purch. Order Exists"; Rec."Blanket Purch. Order Exists")
            {
                ApplicationArea = Jobs;
                BlankZero = true;
                ToolTip = 'Specifies if a blanket purchase order exists for the item on the requisition line.';
                Visible = false;
            }
            field("Document Profile"; "Document Profile")
            {
            }
            field("Reserved Quantity"; Rec."Reserved Quantity")
            {
                Visible = false;
            }
            field(ReservedFor; ReservEngineMgt.CreateForText2(ReservationEntry))
            {
                Caption = 'Reserved For';
                Visible = false;
            }
            field(ReservationCustomerNo; GetReservForInfo(ReturnValue::CustomerNo))
            {
                Caption = 'Reservation Customer No.';
                TableRelation = Customer;
                Visible = false;
            }
            field(ReservationCustomerName; GetReservForInfo(ReturnValue::CustomerName))
            {
                Caption = 'Reservation Customer Name';
                Visible = false;
            }
            field(ReservationVIN; GetReservForInfo(ReturnValue::VIN))
            {
                Caption = 'Reservation VIN';
                TableRelation = Vehicle.VIN;
                Visible = false;
            }
            field(ReservationDealType; GetReservForInfo(ReturnValue::DealType))
            {
                Caption = 'Reservation Deal Type Code';
                TableRelation = "Deal Type";
                Visible = false;
            }
            field(ReservationOrderingPriceType; GetReservForInfo(ReturnValue::OrderingPriceType))
            {
                Caption = 'Reservation Ordering Price Type Code';
                TableRelation = "Ordering Price Type";
                Visible = false;
            }
            field("Ordering Price Type Code"; "Ordering Price Type Code")
            {
                Visible = false;
            }
        }
        addafter("Control 1903326807")
        {
            part(; 33019835)
            {
                SubPageLink = No.=FIELD(No.);
            }
            part(; 25006079)
            {
                SubPageLink = No.=FIELD(No.),
                              Variant Filter=FIELD(Variant Code),
                              Location Filter=FIELD(Location Code);
            }
            part(;25006082)
            {
                SubPageLink = Item No.=FIELD(No.),
                              Variant Code=FIELD(Variant Code),
                              Location Code=FIELD(Location Code);
            }
        }
        addafter("Control 1903326807")
        {
            systempart(;Links)
            {
                Visible = false;
            }
            systempart(;Notes)
            {
                Visible = false;
            }
        }
        moveafter("Control 94";"Control 20")
    }
    actions
    {


        //Unsupported feature: Code Modification on "CalculatePlan(Action 32).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            CalculatePlan.SetTemplAndWorksheet("Worksheet Template Name","Journal Batch Name");
            CalculatePlan.RUNMODAL;
            CLEAR(CalculatePlan);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            //CalculateItemClass.RUNMODAL;
            #1..3
            */
        //end;


        //Unsupported feature: Code Modification on "Action 75.OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            SalesHeader.SETRANGE("No.","Sales Order No.");
            SalesOrder.SETTABLEVIEW(SalesHeader);
            SalesOrder.EDITABLE := FALSE;
            SalesOrder.RUN;
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            //18.01.2013 EDMS P8 >>
            IF "Sales Order No." <> '' THEN BEGIN
              SalesHeader.SETRANGE("No.","Sales Order No.");
              SalesOrder.SETTABLEVIEW(SalesHeader);
              SalesOrder.EDITABLE := FALSE;
              SalesOrder.RUN;
            END;
            IF "Service Order No." <> '' THEN BEGIN
              ServiceHeader.SETRANGE("No.","Service Order No.");
              ServiceOrder.SETTABLEVIEW(ServiceHeader);
              ServiceOrder.EDITABLE := FALSE;
              ServiceOrder.RUN;
            END;
            //18.01.2013 EDMS P8 <<
            */
        //end;


        //Unsupported feature: Code Modification on "CarryOutActionMessage(Action 37).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            PerformAction.SetReqWkshLine(Rec);
            PerformAction.RUNMODAL;
            PerformAction.GetReqWkshLine(Rec);
            CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
            CurrPage.UPDATE(FALSE);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            // Sipradi-YS BEGIN >> Start Archiving Requisition Line
            //ArchiveManagement.ArchiveSparesReqList(Rec);
            //CurrPage.UPDATE(FALSE);
            // Sipradi-YS END
            UserSetup.GET(USERID);
            IF UserSetup."Allow Creating Spare PO" THEN BEGIN
              PerformAction.SetReqWkshLine(Rec);
              PerformAction.RUNMODAL;
              PerformAction.GetReqWkshLine(Rec);
              CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
              CurrPage.UPDATE(FALSE);
            END ELSE
                ERROR(NotValidPermission,USERID,CarryOutActionMsg);
            */
        //end;
        addafter("Action 83")
        {
            action("Requisition Worksheet Report")
            {
                Image = "report";
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    REPORT.RUN(14125509);
                end;
            }
        }
        addafter("Action 53")
        {
            action(GetService)
            {
                Caption = 'Get &Service Orders';
                Image = "Order";

                trigger OnAction()
                begin
                    GetServiceOrders.SetReqWkshLine(Rec,1);
                    GetServiceOrders.RUNMODAL;
                    CLEAR(GetServiceOrders);
                end;
            }
        }
        addafter(CarryOutActionMessage)
        {
            action("Archive Document")
            {

                trigger OnAction()
                var
                    ReqLine: Record "246";
                    UserSetup: Record "91";
                    ArchieveDoc: Label 'Archive Document.';
                begin
                    //AGNI2017CU8 >>
                    UserSetup.GET(USERID);
                    IF UserSetup."Allow Creating Spare PO" THEN BEGIN
                      ArchiveManagement.ArchiveSparesReqList(ReqLine,CurrentJnlBatchName);
                      CurrPage.UPDATE(FALSE);
                    END
                    ELSE
                      ERROR(NotValidPermission,USERID,ArchieveDoc);
                    //AGNI2017CU8 <<
                end;
            }
        }
    }

    var
        CarryOutActionMsg: Label 'carry out Action Messages.';
        UserSetup: Record "91";

    var
        UserSetup: Record "91";


    //Unsupported feature: Property Modification (Id) on "ChangeExchangeRate(Variable 1002)".

    //var
        //>>>> ORIGINAL VALUE:
        //ChangeExchangeRate : 1002;
        //Variable type has not been exported.
        //>>>> MODIFIED VALUE:
        //ChangeExchangeRate : 1001;
        //Variable type has not been exported.


    //Unsupported feature: Property Modification (Id) on "SalesOrder(Variable 1001)".

    //var
        //>>>> ORIGINAL VALUE:
        //SalesOrder : 1001;
        //Variable type has not been exported.
        //>>>> MODIFIED VALUE:
        //SalesOrder : 1002;
        //Variable type has not been exported.

    var
        ServiceHeader: Record "25006145";

    var
        ServiceOrder: Page "25006183";
                          GetServiceOrders: Report "25006110";

    var
        ReservationEntry: Record "337";
        ReservEngineMgt: Codeunit "99000831";
        ReturnValue: Option CustomerNo,VIN,DealType,CustomerName,OrderingPriceType;
        UserProfile: Record "25006067";
        UserProfileMgt: Codeunit "25006002";
        ArchiveManagement: Codeunit "5063";
        NotValidPermission: Label '%1 do not have valid Permission to %2.';
        CalculateItemClass: Report "33019833";
        ReqWorksheet: Report "14125509";


    //Unsupported feature: Code Modification on "OnAfterGetRecord".

    //trigger OnAfterGetRecord()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        ShowShortcutDimCode(ShortcutDimCode);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        ShowShortcutDimCode(ShortcutDimCode);
        CALCFIELDS("Reservation Entry No.");

        // 31.03.2014 Elva Baltic P21 >>
        CLEAR(ReservationEntry);
        IF ReservationEntry.GET(ReservEngineMgt.GetReservForEntryNo("Worksheet Template Name", "Line No.", DATABASE::"Requisition Line", 0, 0, "Journal Batch Name"), FALSE) THEN;
        // 31.03.2014 Elva Baltic P21 <<
        */
    //end;


    //Unsupported feature: Code Insertion on "OnInsertRecord".

    //trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    //begin
        /*
        // 08.04.2014 Elva Baltic P21 >>
        IF ("Location Code" = '') AND (UserProfile."Default Location Code" <> '') THEN
          VALIDATE("Location Code", UserProfile."Default Location Code");
        // 08.04.2014 Elva Baltic P21 <<
        */
    //end;


    //Unsupported feature: Code Insertion (VariableCollection) on "OnOpenPage".

    //trigger (Variable: UserSetup)()
    //Parameters and return type have not been exported.
    //begin
        /*
        */
    //end;


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
        /*
        OpenedFromBatch := ("Journal Batch Name" <> '') AND ("Worksheet Template Name" = '');
        IF OpenedFromBatch THEN BEGIN
          CurrentJnlBatchName := "Journal Batch Name";
        #4..7
        IF NOT JnlSelected THEN
          ERROR('');
        ReqJnlManagement.OpenJnl(CurrentJnlBatchName,Rec);
        */
    //end;
    //>>>> MODIFIED CODE:
    //begin
        /*
        //Sipradi-YS SPR6.1.0 - 291.1 BEGIN >> Filtering User Location
        FILTERGROUP(2);
        UserSetup.GET(USERID);
        IF NOT UserSetup."Allow Creating Spare PO" THEN
          SETRANGE("Location Code",UserSetup."Default Location");
        FILTERGROUP(0);
        //Sipradi-YS SPR6.1.0 - 291.1 END
        #1..10

        // 08.04.2014 Elva Baltic P21 >>
        UserProfile.GET(UserProfileMgt.CurrProfileID);
        IF (UserProfile."Default Location Code" <> '') AND (NOT UserSetup."Allow Creating Spare PO") THEN //SM to remove the filter according to user setup
          SETFILTER("Location Code", UserProfile."Default Location Code");
        // 08.04.2014 Elva Baltic P21 <<

        CALCFIELDS("Reservation Entry No.");
        */
    //end;

    //Unsupported feature: Property Deletion (ToolTipML) on "Control13".


    //Unsupported feature: Property Deletion (ApplicationArea) on "Control13".


    //Unsupported feature: Property Deletion (BlankZero) on "Control13".


    //Unsupported feature: Property Deletion (SourceExpr) on "Control13".


    //Unsupported feature: Property Deletion (Editable) on "Control13".


    //Unsupported feature: Property Deletion (LinksAllowed).

}

