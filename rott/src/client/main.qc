
void CSQC_UpdateView(float vwidth, float vheight, float notmenu)
{
	clearscene();

	setproperty(VF_DRAWENGINESBAR, TRUE);
	setproperty(VF_DRAWCROSSHAIR, TRUE);
	setproperty(VF_DRAWWORLD, TRUE);
	addentities(MASK_ENGINE | MASK_VIEWMODEL);

	renderscene();
}
