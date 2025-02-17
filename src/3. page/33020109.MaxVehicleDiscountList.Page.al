page 33020109 "Max. Vehicle Discount List"
{
    PageType = List;
    SourceTable = Table33019869;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User ID"; "User ID")
                {
                }
                field("Model Version Filter"; "Model Version Filter")
                {
                }
                field(StartDate; StartDate)
                {
                    Caption = 'Starting Date';
                    Editable = false;
                }
                field(DiscountAmount; DiscountAmount)
                {
                    Caption = 'Max. Discount Amount';
                    Editable = false;
                }
                field(Blocked; Blocked)
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
            systempart(; Links)
            {
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Line)
            {
                Caption = 'Line';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 33020103;
                RunPageLink = User ID=FIELD(User ID),
                              Model Version Filter=FIELD(Model Version Filter);

                trigger OnAction()
                begin
                    /*
                    VehMaxDiscLimit.RESET;
                    VehMaxDiscLimit.SETRANGE("User ID","User ID");
                    VehMaxDiscLimit.SETRANGE("Model Version Filter","Model Version Filter");
                    IF VehMaxDiscLimit.FINDFIRST THEN BEGIN
                       VehMaxDiscLimitLineRec.RESET;
                       VehMaxDiscLimitLineRec.SETRANGE("User ID","User ID");
                       VehMaxDiscLimitLineRec.SETRANGE("Model Version Filter","Model Version Filter");
                       IF VehMaxDiscLimitLineRec.FINDFIRST THEN BEGIN
                          VehMaxDiscLimitLineRec."User ID" := VehMaxDiscLimit."User ID";
                          VehMaxDiscLimitLineRec."Model Version Filter" := VehMaxDiscLimit."Model Version Filter";
                          VehMaxDiscLimitLineRec.MODIFY;
                       END ELSE BEGIN
                       VehMaxDiscLimitLineRec.INIT;
                       VehMaxDiscLimitLineRec."User ID" := VehMaxDiscLimit."User ID";
                       VehMaxDiscLimitLineRec."Model Version Filter" := VehMaxDiscLimit."Model Version Filter";
                       VehMaxDiscLimitLineRec.INSERT;
                       END;
                    END;
                    VehMaxDiscLimitLine.SETTABLEVIEW(VehMaxDiscLimit);
                    VehMaxDiscLimitLine.RUN;
                    */

                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateDiscount;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        UpdateDiscount;
    end;

    var
        VehMaxDiscLimit: Record "33019869";
        VehMaxDiscLimitLineRec: Record "33019861";
        StartDate: Date;
        DiscountAmount: Decimal;

    [Scope('Internal')]
    procedure UpdateDiscount()
    begin
        VehMaxDiscLimitLineRec.RESET;
        VehMaxDiscLimitLineRec.SETRANGE("User ID","User ID");
        VehMaxDiscLimitLineRec.SETRANGE("Model Version Filter","Model Version Filter");
        VehMaxDiscLimitLineRec.SETRANGE("Starting Date",0D,WORKDATE);
        IF VehMaxDiscLimitLineRec.FINDLAST THEN BEGIN
           VehMaxDiscLimitLineRec.SETRANGE("Starting Date",VehMaxDiscLimitLineRec."Starting Date");
           StartDate := VehMaxDiscLimitLineRec."Starting Date";
           DiscountAmount := VehMaxDiscLimitLineRec."Max. Discount Amount";
        END;
    end;
}

