pageextension 50675 pageextension50675 extends "Order Tracking"
{
    procedure SetServiceLine(var CurrentServiceLine: Record "25006146")
    begin
        TrackingMgt.SetServiceLine(CurrentServiceLine);

        CurrItemNo := CurrentServiceLine."No.";
        CurrQuantity := CurrentServiceLine."Outstanding Qty. (Base)";
        StartingDate := CurrentServiceLine."Planned Service Date";
        EndingDate := CurrentServiceLine."Planned Service Date";
    end;
}

