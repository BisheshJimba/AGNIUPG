page 33019864 "Appraisal self"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    PopulateAllFields = true;
    SourceTable = Table5200;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("Full Name"; "Full Name")
                {
                }
                field("First Appraised"; "First Appraised")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Annual Appraise")
            {
                Caption = 'Annual Appraise';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ApprisalType_: Option " ",Self,Manager,"Manager 360";
                begin
                    CLEAR(FiscalYearPage);
                    FiscalYearPage.SETTABLEVIEW(Rec);
                    //MESSAGE('%1',Rec);
                    //Rec.setApprisalType(ApprisalType_::Self);
                    FiscalYearPage.setApprisalType(ApprisalType_::Self);
                    FiscalYearPage.SETRECORD(Rec);

                    FiscalYearPage.RUN;
                end;
            }
            action("Half-Annual Appraise")
            {
                Caption = 'Half-Annual Appraise';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ApprisalType_: Option " ",Self,Manager,"Manager 360";
                begin
                    CLEAR(HalfYearFiscalPage);
                    HalfYearFiscalPage.SETTABLEVIEW(Rec);
                    HalfYearFiscalPage.SETRECORD(Rec);
                    HalfAppraisalPage.setApprisalType(ApprisalType_::Self);
                    //Rec.setApprisalType(ApprisalType_::Self);
                    HalfYearFiscalPage.RUN;
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        UserSetup: Record "91";
        EmployeeRec: Record "5200";
        "filter": Text;
    begin
        /*//Setting filter to list out Employee Codes under the Current UserID
        HRPermission.GET(USERID);
        //IF NOT HRPermission."HR Admin" THEN BEGIN
        EmployeeRec.RESET;
        EmployeeRec.SETCURRENTKEY("User ID");
        EmployeeRec.SETRANGE("User ID",USERID);
        IF EmployeeRec.FINDFIRST THEN BEGIN
          {
          IF filter = '' THEN
            filter := EmployeeRec."First Appraisal ID"
          ELSE
            filter += '|' + EmployeeRec."Second Appraisal ID";
          END;}
          IF filter = '' THEN
          filter := EmployeeRec."No."
        
        END;
        
        //END;
        
        IF filter <> '' THEN BEGIN
        */
        FILTERGROUP(2);
        SETFILTER(Rec."User ID", USERID);
        FILTERGROUP(0);


    end;

    var
        EmpRec: Record "5200";
        ManagerID: Code[20];
        EmpAppr: Record "33020361";
        AppraisalPage: Page "33020369";
        Appraisal: Record "33020361";
        "Fiscal Year": Code[10];
        Calendar: Record "33020302";
        Visible: Boolean;
        FirstAppraisalID: Code[20];
        HalfAppraisalPage: Page "33020444";
        YearsWorked: Decimal;
        StartFiscalYear: Text[30];
        EndFiscalYear: Text[30];
        Window: Dialog;
        int: Integer;
        HRPermission: Record "33020304";
        EmpAppr1: Record "33020361";
        FiscalYearPage: Page "33020334";
        HalfYearFiscalPage: Page "33020336";
}

