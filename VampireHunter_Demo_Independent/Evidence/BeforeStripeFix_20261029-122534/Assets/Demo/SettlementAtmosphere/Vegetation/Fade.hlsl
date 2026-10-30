#ifndef SETTLEMENT_DITHER_INCLUDED
#define SETTLEMENT_DITHER_INCLUDED
float _Visibility;
void SettlementDither(float2 positionCS) {
 float noise=frac(52.9829189*frac(dot(floor(positionCS),float2(.06711056,.00583715))));
 clip(_Visibility-noise-.00001);
}
#endif
