pageextension 50285 pageextension50285 extends "Analysis View List"
{
    actions
    {

        //Unsupported feature: Code Modification on "EditAnalysis(Action 17).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        AnalysisbyDimensions.SetAnalysisViewCode(Code);
        AnalysisbyDimensions.RUN;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*

        //AnalysisView.RUN;
        AnalysisbyDimensions.SetAnalysisViewCode(Code);
        AnalysisbyDimensions.RUN;
        */
        //end;
    }

    var
        AnalysisView: Page "555";
}

