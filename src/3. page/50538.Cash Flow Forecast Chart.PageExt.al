pageextension 50538 pageextension50538 extends "Cash Flow Forecast Chart"
{
    layout
    {

        //Unsupported feature: Property Modification (Name) on "StatusText(Control 12)".


        //Unsupported feature: Property Insertion (ControlAddIn) on "StatusText(Control 12)".

        modify(BusinessChart)
        {

            //Unsupported feature: Property Modification (Name) on "BusinessChart(Control 5)".

            Caption = 'Status Text';

            //Unsupported feature: Property Insertion (SourceExpr) on "BusinessChart(Control 5)".

            ShowCaption = false;
        }

        //Unsupported feature: Property Deletion (CaptionML) on "StatusText(Control 12)".


        //Unsupported feature: Property Deletion (SourceExpr) on "StatusText(Control 12)".


        //Unsupported feature: Property Deletion (ShowCaption) on "StatusText(Control 12)".


        //Unsupported feature: Property Deletion (ControlAddIn) on "BusinessChart(Control 5)".

        moveafter("Control 1"; "Control 23")
        moveafter("Control 23"; BusinessChart)
    }
}

