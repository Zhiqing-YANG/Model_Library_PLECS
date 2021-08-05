/*
 * Implementation file for: SM_Coder_FSM_PLL_ACC/Circuit/LaunchPad
 * Generated with         : PLECS 4.4.5
 *                          TI2837xS 1.2
 * Generated on           : 5 Aug 2021 17:46:50
 */

#include "LaunchPad.h"
#ifndef PLECS_HEADER_LaunchPad_h_
#error The wrong header file "LaunchPad.h" was included. Please check your
#error include path to see whether this file name conflicts with the name
#error of another header file.
#endif                                 /* PLECS_HEADER_LaunchPad_h_ */

#if defined(__GNUC__) && (__GNUC__ > 4)
#   define _ALIGNMENT                  16
#   define _RESTRICT                   __restrict
#   define _ALIGN                      __attribute__((aligned(_ALIGNMENT)))
#   if defined(__clang__)
#      if __has_builtin(__builtin_assume_aligned)
#         define _ASSUME_ALIGNED(a)    __builtin_assume_aligned(a, _ALIGNMENT)
#      else
#         define _ASSUME_ALIGNED(a)    a
#      endif

#   else
#      define _ASSUME_ALIGNED(a)       __builtin_assume_aligned(a, _ALIGNMENT)
#   endif

#else
#   ifndef _RESTRICT
#      define _RESTRICT
#   endif

#   ifndef _ALIGN
#      define _ALIGN
#   endif

#   ifndef _ASSUME_ALIGNED
#      define _ASSUME_ALIGNED(a)       a
#   endif
#endif

#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <math.h>
#include <string.h>
#include "hal.h"
#include "dispatcher.h"
#define PLECSRunTimeError(msg)         LaunchPad_errorStatus = msg

struct FSM_Struct {
  int fsm_isMajorTimeStep;
  double fsm_currentTime;
  const double *fsm_internalConstants;
  const double ***fsm_inputs;
  double ***fsm_outputs;
  double *fsm_discStates;
  double *fsm_zCSignals;
  int *fsm_takenTransitions;
  double *fsm_nextSampleHit;
  double fsm_samplingFrequency;
  const char **fsm_errorStatus;
  const char **fsm_warningStatus;
};

static struct FSM_Struct LaunchPad_fsm_struct[1];
static const double LaunchPad_UNCONNECTED = 0;
static double LaunchPad_D_double[1];
static double LaunchPad_deriv[6] _ALIGN;
void LaunchPad_0_fsm_start(const struct FSM_Struct *fsm_struct);
void LaunchPad_0_fsm_output(const struct FSM_Struct *fsm_struct);
static uint32_t LaunchPad_tickLo;
static int32_t LaunchPad_tickHi;
LaunchPad_BlockOutputs LaunchPad_B;
LaunchPad_ModelStates LaunchPad_X _ALIGN;
const char * LaunchPad_errorStatus;
const double LaunchPad_sampleTime = 5.00000000000000024e-05;
const char * const LaunchPad_checksum =
  "a20e2fb250e0b9714169f5becc2f07effb7016a4";

/* Target declarations */
void LaunchPad_background(void)
{
}

static void Tasks(void * const aParam)
{
  LaunchPad_step();
}

void LaunchPad_initialize(double time)
{
  double remainder;
  size_t i;
  LaunchPad_errorStatus = NULL;
  LaunchPad_tickHi = floor(time/(4294967296.0*LaunchPad_sampleTime));
  remainder = time - LaunchPad_tickHi*4294967296.0*LaunchPad_sampleTime;
  LaunchPad_tickLo = floor(remainder/LaunchPad_sampleTime + .5);
  remainder -= LaunchPad_tickLo*LaunchPad_sampleTime;
  if (fabs(remainder) > 1e-6*fabs(time)) {
    LaunchPad_errorStatus =
      "Start time must be an integer multiple of the base sample time.";
  }

  /* Target pre-initialization */
  // configure multi-purpose timer 0 at 20000.0 Hz
  {
    DISPR_setupTimer(0, 9500);
  }

  // configure PWM1 at 10000.0 Hz in triangle mode (soc='zp')
  {
    PWM_Params_t *params = HAL_getDefaultPwmParams();
    params->outMode = PWM_OUTPUT_MODE_DUAL;
    params->reg.TBPRD = 2375;
    params->reg.ETSEL.bit.SOCASEL = 3;
    params->reg.TBCTL.bit.CTRMODE = 2;

    // active state is high
    params->reg.DBCTL.bit.POLSEL = 2;
    params->reg.TZSEL.bit.CBC1 = 0;
    params->reg.TZSEL.bit.CBC2 = 0;
    params->reg.TZSEL.bit.CBC3 = 0;
    params->reg.TZSEL.bit.OSHT1 = 0;
    params->reg.TZSEL.bit.OSHT2 = 0;
    params->reg.TZSEL.bit.OSHT3 = 0;
    HAL_setupPwm(0, 1, params);

    // configure deadtime to 3.000000e-06 seconds
    HAL_setPwmDeadtimeCounts(0, 142, 142);

    // PWM sequence starting with active state
    HAL_setPwmSequence(0, 1);
  }

  // configure PWM2 at 10000.0 Hz in triangle mode (soc='zp')
  {
    PWM_Params_t *params = HAL_getDefaultPwmParams();
    params->outMode = PWM_OUTPUT_MODE_DUAL;
    params->reg.TBPRD = 2375;
    params->reg.ETSEL.bit.SOCASEL = 3;
    params->reg.TBCTL.bit.CTRMODE = 2;

    // active state is high
    params->reg.DBCTL.bit.POLSEL = 2;
    params->reg.TZSEL.bit.CBC1 = 0;
    params->reg.TZSEL.bit.CBC2 = 0;
    params->reg.TZSEL.bit.CBC3 = 0;
    params->reg.TZSEL.bit.OSHT1 = 0;
    params->reg.TZSEL.bit.OSHT2 = 0;
    params->reg.TZSEL.bit.OSHT3 = 0;
    HAL_setupPwm(1, 2, params);

    // configure deadtime to 3.000000e-06 seconds
    HAL_setPwmDeadtimeCounts(1, 142, 142);

    // PWM sequence starting with active state
    HAL_setPwmSequence(1, 1);
  }

  // configure PWM3 at 10000.0 Hz in triangle mode (soc='zp')
  {
    PWM_Params_t *params = HAL_getDefaultPwmParams();
    params->outMode = PWM_OUTPUT_MODE_DUAL;
    params->reg.TBPRD = 2375;
    params->reg.ETSEL.bit.SOCASEL = 3;
    params->reg.TBCTL.bit.CTRMODE = 2;

    // active state is high
    params->reg.DBCTL.bit.POLSEL = 2;
    params->reg.TZSEL.bit.CBC1 = 0;
    params->reg.TZSEL.bit.CBC2 = 0;
    params->reg.TZSEL.bit.CBC3 = 0;
    params->reg.TZSEL.bit.OSHT1 = 0;
    params->reg.TZSEL.bit.OSHT2 = 0;
    params->reg.TZSEL.bit.OSHT3 = 0;
    HAL_setupPwm(2, 3, params);

    // configure deadtime to 3.000000e-06 seconds
    HAL_setPwmDeadtimeCounts(2, 142, 142);

    // PWM sequence starting with active state
    HAL_setPwmSequence(2, 1);
  }

  // configure ADC B
  {
    AIN_AdcParams_t *params = HAL_getDefaultAdcParams();
    HAL_setupAdc(1, 1, params);
  }

  // configure SOC0 of ADC-B to measure ADCIN3
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(1, 0, 3, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure SOC1 of ADC-B to measure ADCIN4
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(1, 1, 4, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure SOC2 of ADC-B to measure ADCIN5
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(1, 2, 5, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure ADC C
  {
    AIN_AdcParams_t *params = HAL_getDefaultAdcParams();
    HAL_setupAdc(0, 2, params);
  }

  // configure SOC0 of ADC-C to measure ADCIN2
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(0, 0, 2, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure SOC1 of ADC-C to measure ADCIN3
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(0, 1, 3, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure SOC2 of ADC-C to measure ADCIN4
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(0, 2, 4, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure SOC3 of ADC-C to measure ADCIN5
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(0, 3, 5, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  {
    static int taskId = 0;

    // Task 0 at 2.000000e+04 Hz
    DISPR_registerTask(0, &Tasks, 9500L, (void *)&taskId);
  }

  /* Initialization for Integrator : 'LaunchPad/Controller/SRF Phas-Locked Loop/Integrator' */
  LaunchPad_X.Integrator_x = 0.;

  /* Initialization for Transfer Function : 'LaunchPad/Controller/Alternating-Current Control/PI/VFF/LPF' */
  LaunchPad_X.LPF[0] = 0.;
  LaunchPad_X.LPF[1] = 0.;

  /* Initialization for Digital In : 'LaunchPad/SW_OLPLL' */
  HAL_setupDigitalIn(0, 95);

  /* Initialization for Digital In : 'LaunchPad/SW_ACC' */
  HAL_setupDigitalIn(1, 139);

  /* Initialization for State Machine : 'LaunchPad/State Machine' */
  {
    static const double* fsm_inputPtrs[] = { &LaunchPad_B.SW_OLPLL,
      &LaunchPad_B.SW_OLPLL, &LaunchPad_B.SW_ACC, &LaunchPad_B.SW_ACC,
      &LaunchPad_D_double[0] };

    static const double** fsm_inputs[] = { &fsm_inputPtrs[0], &fsm_inputPtrs[1],
      &fsm_inputPtrs[2], &fsm_inputPtrs[3], &fsm_inputPtrs[4] };

    static double* fsm_outputPtrs[] = { &LaunchPad_B.StateMachine[0],
      &LaunchPad_B.StateMachine[1], &LaunchPad_B.StateMachine[2],
      &LaunchPad_B.StateMachine[3], &LaunchPad_B.StateMachine[4],
      &LaunchPad_B.StateMachine[5], &LaunchPad_B.StateMachine[6],
      &LaunchPad_B.StateMachine[7] };

    static double** fsm_outputs[] = { &fsm_outputPtrs[0], &fsm_outputPtrs[1],
      &fsm_outputPtrs[2], &fsm_outputPtrs[3], &fsm_outputPtrs[4],
      &fsm_outputPtrs[5], &fsm_outputPtrs[6], &fsm_outputPtrs[7] };

    static int fsm_takenTransitions[1];
    static double fsm_nextSampleHit;
    static const char* fsm_errorStatus = NULL;
    static const char* fsm_warningStatus = NULL;
    LaunchPad_fsm_struct[0].fsm_isMajorTimeStep = 1;
    LaunchPad_fsm_struct[0].fsm_internalConstants = NULL;
    LaunchPad_fsm_struct[0].fsm_inputs = fsm_inputs;
    LaunchPad_fsm_struct[0].fsm_outputs = fsm_outputs;
    LaunchPad_fsm_struct[0].fsm_discStates = &LaunchPad_X.StateMachine[0];
    LaunchPad_fsm_struct[0].fsm_zCSignals = NULL;
    LaunchPad_fsm_struct[0].fsm_takenTransitions = fsm_takenTransitions;
    LaunchPad_fsm_struct[0].fsm_nextSampleHit = &fsm_nextSampleHit;
    LaunchPad_fsm_struct[0].fsm_samplingFrequency = 1.0 / 5e-05;
    LaunchPad_fsm_struct[0].fsm_errorStatus = &fsm_errorStatus;
    LaunchPad_fsm_struct[0].fsm_warningStatus = &fsm_warningStatus;
    LaunchPad_0_fsm_start(&LaunchPad_fsm_struct[0]);
    if (*LaunchPad_fsm_struct[0].fsm_errorStatus)
      LaunchPad_errorStatus = *LaunchPad_fsm_struct[0].fsm_errorStatus;
  }

  /* Initialization for Integrator : 'LaunchPad/Controller/Alternating-Current Control/PI/d-axis\nPI Regulator/Integrator' */
  LaunchPad_X.Integrator_1_x = 0.;

  /* Initialization for Integrator : 'LaunchPad/Controller/Alternating-Current Control/PI/q-axis\nPI Regulator1/Integrator' */
  LaunchPad_X.Integrator_2_x = 0.;

  /* Initialization for Digital Out : 'LaunchPad/Contactor' */
  HAL_setupDigitalOut(0, 19, false);

  /* Initialization for Digital Out : 'LaunchPad/State_Units0' */
  HAL_setupDigitalOut(1, 130, false);

  /* Initialization for Digital Out : 'LaunchPad/State_Units1' */
  HAL_setupDigitalOut(2, 131, false);

  /* Initialization for Digital Out : 'LaunchPad/State_Units2' */
  HAL_setupDigitalOut(3, 66, false);

  /* Initialization for Digital Out : 'LaunchPad/State_Units3' */
  HAL_setupDigitalOut(4, 16, false);

  /* Initialization for Integrator : 'LaunchPad/Controller/SRF Phas-Locked Loop/PLL\nPI Regulator/Integrator' */
  LaunchPad_X.Integrator_3_x = 0.;
}

void LaunchPad_step()
{
  if (LaunchPad_errorStatus) {
    return;
  }

  /* Saturation : 'LaunchPad/ADC Decode/Saturation'
   * incorporates
   *  Gain : 'LaunchPad/ADC Decode/Gain'
   *  ADC : 'LaunchPad/ADC C'
   */
  LaunchPad_B.Saturation = 6.*(HAL_getAnalogInF(0, 0));
  if (LaunchPad_B.Saturation > 11.) {
    LaunchPad_B.Saturation = 11.;
  } else if (LaunchPad_B.Saturation < 0.) {
    LaunchPad_B.Saturation = 0.;
  }

  /* Function : 'LaunchPad/ADC Decode/Calibration/With calibration/Fcn'
   * incorporates
   *  ADC : 'LaunchPad/ADC B'
   */
  LaunchPad_B.Fcn = (((HAL_getAnalogInF(1, 0)) - 1.49700000000000011) -
                     -0.0100000000000000002) * 14.1904356463743433;

  /* Integrator : 'LaunchPad/Controller/SRF Phas-Locked Loop/Integrator' */
  LaunchPad_B.Integrator = LaunchPad_X.Integrator_x;

  /* Compare to Constant : 'LaunchPad/Controller/SRF Phas-Locked Loop/Compare to\nConstant' */
  LaunchPad_B.CompareToConstant = LaunchPad_B.Integrator >= 6.28318530717958623;

  /* Integrator : 'LaunchPad/Controller/SRF Phas-Locked Loop/Integrator' */
  if ((LaunchPad_B.CompareToConstant != 0)) {
    LaunchPad_X.Integrator_x = 0.;
  }

  LaunchPad_B.Integrator_i1 = LaunchPad_X.Integrator_x;

  /* Trigonometric Function : 'LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF7/Cos' */
  LaunchPad_B.Cos = cos(LaunchPad_B.Integrator_i1);

  /* Function : 'LaunchPad/ADC Decode/Calibration/With calibration/Fcn1'
   * incorporates
   *  ADC : 'LaunchPad/ADC B'
   */
  LaunchPad_B.Fcn1 = (((HAL_getAnalogInF(1, 1)) - 1.49700000000000011) -
                      -0.0100000000000000002) * 14.1904356463743433;

  /* Trigonometric Function : 'LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF7/Sin' */
  LaunchPad_B.Sin = sin(LaunchPad_B.Integrator_i1);

  /* Function : 'LaunchPad/ADC Decode/Calibration/With calibration/Fcn2'
   * incorporates
   *  ADC : 'LaunchPad/ADC B'
   */
  LaunchPad_B.Fcn2 = (((HAL_getAnalogInF(1, 2)) - 1.49700000000000011) - 0.) *
    14.1904356463743433;

  /* Function : 'LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF7/abc->d' */
  LaunchPad_B.abc_d = 0.66666666666666663 * (((LaunchPad_B.Fcn * LaunchPad_B.Cos)
    + (LaunchPad_B.Fcn1 * ((-0.5 * LaunchPad_B.Cos) + (0.866025403784438597 *
    LaunchPad_B.Sin)))) + (LaunchPad_B.Fcn2 * ((-0.5 * LaunchPad_B.Cos) -
    (0.866025403784438597 * LaunchPad_B.Sin))));

  /* Sum : 'LaunchPad/Controller/Alternating-Current Control/PI/Sum' */
  LaunchPad_B.Sum = LaunchPad_B.Saturation - LaunchPad_B.abc_d;

  /* Function : 'LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF7/abc->q' */
  LaunchPad_B.abc_q = 0.66666666666666663 * ((((-LaunchPad_B.Fcn) *
    LaunchPad_B.Sin) + (LaunchPad_B.Fcn1 * ((0.5 * LaunchPad_B.Sin) +
    (0.866025403784438597 * LaunchPad_B.Cos)))) + (LaunchPad_B.Fcn2 * ((0.5 *
    LaunchPad_B.Sin) - (0.866025403784438597 * LaunchPad_B.Cos))));

  /* Sum : 'LaunchPad/Controller/Alternating-Current Control/PI/Sum2'
   * incorporates
   *  Constant : 'LaunchPad/Controller/Alternating-Current Control/PI/Constant'
   */
  LaunchPad_B.Sum2 = 0. - LaunchPad_B.abc_q;

  /* Transfer Function : 'LaunchPad/Controller/Alternating-Current Control/PI/VFF/LPF' */
  LaunchPad_B.LPF[0] = 3141.59265358979292*LaunchPad_X.LPF[0];
  LaunchPad_B.LPF[1] = 3141.59265358979292*LaunchPad_X.LPF[1];

  /* Digital In : 'LaunchPad/SW_OLPLL' */
  LaunchPad_B.SW_OLPLL = HAL_getDigitalIn(0);

  /* Digital In : 'LaunchPad/SW_ACC' */
  LaunchPad_B.SW_ACC = HAL_getDigitalIn(1);

  /* Function : 'LaunchPad/ADC Decode/Calibration/With calibration/Fcn3'
   * incorporates
   *  ADC : 'LaunchPad/ADC C'
   */
  LaunchPad_B.Fcn3 = (((HAL_getAnalogInF(0, 1)) - 1.49700000000000011) -
                      -0.00300000000000000006) * 183.447988326037091;

  /* Function : 'LaunchPad/ADC Decode/Calibration/With calibration/Fcn4'
   * incorporates
   *  ADC : 'LaunchPad/ADC C'
   */
  LaunchPad_B.Fcn4 = (((HAL_getAnalogInF(0, 2)) - 1.49700000000000011) -
                      -0.00300000000000000006) * 183.447988326037091;

  /* Function : 'LaunchPad/ADC Decode/Calibration/With calibration/Fcn5'
   * incorporates
   *  ADC : 'LaunchPad/ADC C'
   */
  LaunchPad_B.Fcn5 = (((HAL_getAnalogInF(0, 3)) - 1.49700000000000011) -
                      -0.00300000000000000006) * 183.447988326037091;

  /* State Machine : 'LaunchPad/State Machine' */
  LaunchPad_D_double[0] = ((fabs(LaunchPad_B.Fcn3) >= 150.) || (fabs
    (LaunchPad_B.Fcn4) >= 150.) || (fabs(LaunchPad_B.Fcn5) >= 150.)) || ((fabs
    (LaunchPad_B.Fcn) >= 20.) || (fabs(LaunchPad_B.Fcn1) >= 20.) || (fabs
    (LaunchPad_B.Fcn2) >= 20.));
  LaunchPad_0_fsm_output(&LaunchPad_fsm_struct[0]);
  if (*LaunchPad_fsm_struct[0].fsm_errorStatus)
    LaunchPad_errorStatus = *LaunchPad_fsm_struct[0].fsm_errorStatus;

  /* Integrator : 'LaunchPad/Controller/Alternating-Current Control/PI/d-axis\nPI Regulator/Integrator' */
  if (((!LaunchPad_X.Integrator_1_prevReset && LaunchPad_B.StateMachine[1]) ||
       (LaunchPad_X.Integrator_1_prevReset && !LaunchPad_B.StateMachine[1]))) {
    LaunchPad_X.Integrator_1_x = 0.;
  }

  if (LaunchPad_X.Integrator_1_x > 200.) {
    LaunchPad_X.Integrator_1_x = 200.;
  } else if (LaunchPad_X.Integrator_1_x < -200.) {
    LaunchPad_X.Integrator_1_x = -200.;
  }

  LaunchPad_B.Integrator_1 = LaunchPad_X.Integrator_1_x;

  /* Sum : 'LaunchPad/Controller/Alternating-Current Control/PI/Sum7'
   * incorporates
   *  Sum : 'LaunchPad/Controller/Alternating-Current Control/PI/d-axis\nPI Regulator/Sum'
   *  Gain : 'LaunchPad/Controller/Alternating-Current Control/PI/d-axis\nPI Regulator/Gain'
   *  Gain : 'LaunchPad/Controller/Alternating-Current Control/PI/Gain'
   */
  LaunchPad_B.Sum7 = LaunchPad_B.LPF[0] + ((15.5999999999999996*LaunchPad_B.Sum)
    + LaunchPad_B.Integrator_1) - (0.785398163397448279*LaunchPad_B.abc_q);

  /* Trigonometric Function : 'LaunchPad/Controller/Alternating-Current Control/PI/RRF->3ph/Cos' */
  LaunchPad_B.Cos_1 = cos(LaunchPad_B.Integrator_i1);

  /* Integrator : 'LaunchPad/Controller/Alternating-Current Control/PI/q-axis\nPI Regulator1/Integrator' */
  if (((!LaunchPad_X.Integrator_2_prevReset && LaunchPad_B.StateMachine[1]) ||
       (LaunchPad_X.Integrator_2_prevReset && !LaunchPad_B.StateMachine[1]))) {
    LaunchPad_X.Integrator_2_x = 0.;
  }

  if (LaunchPad_X.Integrator_2_x > 200.) {
    LaunchPad_X.Integrator_2_x = 200.;
  } else if (LaunchPad_X.Integrator_2_x < -200.) {
    LaunchPad_X.Integrator_2_x = -200.;
  }

  LaunchPad_B.Integrator_2 = LaunchPad_X.Integrator_2_x;

  /* Sum : 'LaunchPad/Controller/Alternating-Current Control/PI/Sum8'
   * incorporates
   *  Gain : 'LaunchPad/Controller/Alternating-Current Control/PI/Gain2'
   *  Sum : 'LaunchPad/Controller/Alternating-Current Control/PI/q-axis\nPI Regulator1/Sum'
   *  Gain : 'LaunchPad/Controller/Alternating-Current Control/PI/q-axis\nPI Regulator1/Gain'
   */
  LaunchPad_B.Sum8 = (0.785398163397448279*LaunchPad_B.abc_d) +
    ((15.5999999999999996*LaunchPad_B.Sum2) + LaunchPad_B.Integrator_2) +
    LaunchPad_B.LPF[1];

  /* Trigonometric Function : 'LaunchPad/Controller/Alternating-Current Control/PI/RRF->3ph/Sin' */
  LaunchPad_B.Sin_1 = sin(LaunchPad_B.Integrator_i1);

  /* Function : 'LaunchPad/Controller/Alternating-Current Control/PI/RRF->3ph/dq->a' */
  LaunchPad_B.dq_a = (LaunchPad_B.Sum7 * LaunchPad_B.Cos_1) - (LaunchPad_B.Sum8 *
    LaunchPad_B.Sin_1);

  /* Function : 'LaunchPad/Controller/Alternating-Current Control/PI/RRF->3ph/dq->b' */
  LaunchPad_B.dq_b = (LaunchPad_B.Sum7 * ((-0.5 * LaunchPad_B.Cos_1) +
    (0.866025403784438597 * LaunchPad_B.Sin_1))) + (LaunchPad_B.Sum8 * ((0.5 *
    LaunchPad_B.Sin_1) + (0.866025403784438597 * LaunchPad_B.Cos_1)));

  /* Gain : 'LaunchPad/Controller/Alternating-Current Control/PI/Gain3'
   * incorporates
   *  Sum : 'LaunchPad/Controller/Alternating-Current Control/PI/RRF->3ph/Sum1'
   */
  LaunchPad_B.Gain3[0] = 0.0111111111111111115*LaunchPad_B.dq_a;
  LaunchPad_B.Gain3[1] = 0.0111111111111111115*LaunchPad_B.dq_b;
  LaunchPad_B.Gain3[2] = 0.0111111111111111115*(-LaunchPad_B.dq_b -
    LaunchPad_B.dq_a);

  /* Saturation : 'LaunchPad/Controller/Alternating-Current Control/PI/Saturation' */
  LaunchPad_B.Saturation_1[0] = LaunchPad_B.Gain3[0];
  if (LaunchPad_B.Saturation_1[0] > 1.) {
    LaunchPad_B.Saturation_1[0] = 1.;
  } else if (LaunchPad_B.Saturation_1[0] < -1.) {
    LaunchPad_B.Saturation_1[0] = -1.;
  }

  LaunchPad_B.Saturation_1[1] = LaunchPad_B.Gain3[1];
  if (LaunchPad_B.Saturation_1[1] > 1.) {
    LaunchPad_B.Saturation_1[1] = 1.;
  } else if (LaunchPad_B.Saturation_1[1] < -1.) {
    LaunchPad_B.Saturation_1[1] = -1.;
  }

  LaunchPad_B.Saturation_1[2] = LaunchPad_B.Gain3[2];
  if (LaunchPad_B.Saturation_1[2] > 1.) {
    LaunchPad_B.Saturation_1[2] = 1.;
  } else if (LaunchPad_B.Saturation_1[2] < -1.) {
    LaunchPad_B.Saturation_1[2] = -1.;
  }

  /* Trigonometric Function : 'LaunchPad/Controller/OL/RRF->3ph/Cos' */
  LaunchPad_B.Cos_2 = cos(LaunchPad_B.Integrator_i1);

  /* Trigonometric Function : 'LaunchPad/Controller/OL/RRF->3ph/Sin' */
  LaunchPad_B.Sin_2 = sin(LaunchPad_B.Integrator_i1);

  /* Function : 'LaunchPad/Controller/OL/RRF->3ph/dq->a'
   * incorporates
   *  Constant : 'LaunchPad/Controller/OL/vc_d_ref'
   *  Constant : 'LaunchPad/Controller/OL/vc_q_ref'
   */
  LaunchPad_B.dq_a_1 = (0.900000000000000022 * LaunchPad_B.Cos_2) - (0. *
    LaunchPad_B.Sin_2);

  /* Function : 'LaunchPad/Controller/OL/RRF->3ph/dq->b'
   * incorporates
   *  Constant : 'LaunchPad/Controller/OL/vc_d_ref'
   *  Constant : 'LaunchPad/Controller/OL/vc_q_ref'
   */
  LaunchPad_B.dq_b_1 = (0.900000000000000022 * ((-0.5 * LaunchPad_B.Cos_2) +
    (0.866025403784438597 * LaunchPad_B.Sin_2))) + (0. * ((0.5 *
    LaunchPad_B.Sin_2) + (0.866025403784438597 * LaunchPad_B.Cos_2)));

  /* Signal Switch : 'LaunchPad/Controller/output selector/Switch' */
  LaunchPad_B.Switch = LaunchPad_B.StateMachine[1] != 0.;

  /* Signal Switch : 'LaunchPad/Controller/output selector/Switch1' */
  LaunchPad_B.Switch1 = LaunchPad_B.StateMachine[0] != 0.;

  /* PWM  : 'LaunchPad/PWM' */
  HAL_setPwmDuty(0, LaunchPad_B.Switch1 ? (LaunchPad_B.Switch ? ((0.5*
    LaunchPad_B.Saturation_1[0]) + 0.5) : ((0.5*LaunchPad_B.dq_a_1) + 0.5)) : 0.);
  HAL_setPwmDuty(1, LaunchPad_B.Switch1 ? (LaunchPad_B.Switch ? ((0.5*
    LaunchPad_B.Saturation_1[1]) + 0.5) : ((0.5*LaunchPad_B.dq_b_1) + 0.5)) : 0.);
  HAL_setPwmDuty(2, LaunchPad_B.Switch1 ? (LaunchPad_B.Switch ? ((0.5*
    LaunchPad_B.Saturation_1[2]) + 0.5) : ((0.5*(-LaunchPad_B.dq_b_1 -
    LaunchPad_B.dq_a_1)) + 0.5)) : 0.);

  /* Digital Out : 'LaunchPad/Contactor' */
  HAL_setDigitalOut(0, LaunchPad_B.StateMachine[2]);

  /* Digital Out : 'LaunchPad/State_Units0' */
  HAL_setDigitalOut(1, LaunchPad_B.StateMachine[4]);

  /* Digital Out : 'LaunchPad/State_Units1' */
  HAL_setDigitalOut(2, LaunchPad_B.StateMachine[5]);

  /* Digital Out : 'LaunchPad/State_Units2' */
  HAL_setDigitalOut(3, LaunchPad_B.StateMachine[6]);

  /* Digital Out : 'LaunchPad/State_Units3' */
  HAL_setDigitalOut(4, LaunchPad_B.StateMachine[7]);

  /* Trigonometric Function : 'LaunchPad/Controller/SRF Phas-Locked Loop/3ph->RRF/Sin' */
  LaunchPad_B.Sin_3 = sin(LaunchPad_B.Integrator_i1);

  /* Trigonometric Function : 'LaunchPad/Controller/SRF Phas-Locked Loop/3ph->RRF/Cos' */
  LaunchPad_B.Cos_3 = cos(LaunchPad_B.Integrator_i1);

  /* Function : 'LaunchPad/Controller/SRF Phas-Locked Loop/3ph->RRF/abc->q' */
  LaunchPad_B.abc_q_1 = 0.66666666666666663 * ((((-LaunchPad_B.Fcn3) *
    LaunchPad_B.Sin_3) + (LaunchPad_B.Fcn4 * ((0.5 * LaunchPad_B.Sin_3) +
    (0.866025403784438597 * LaunchPad_B.Cos_3)))) + (LaunchPad_B.Fcn5 * ((0.5 *
    LaunchPad_B.Sin_3) - (0.866025403784438597 * LaunchPad_B.Cos_3))));

  /* Integrator : 'LaunchPad/Controller/SRF Phas-Locked Loop/PLL\nPI Regulator/Integrator' */
  if (((!LaunchPad_X.Integrator_3_prevReset && LaunchPad_B.StateMachine[0]) ||
       (LaunchPad_X.Integrator_3_prevReset && !LaunchPad_B.StateMachine[0]))) {
    LaunchPad_X.Integrator_3_x = 0.;
  }

  LaunchPad_B.Integrator_3 = LaunchPad_X.Integrator_3_x;

  /* Sum : 'LaunchPad/Controller/SRF Phas-Locked Loop/Sum3'
   * incorporates
   *  Constant : 'LaunchPad/Controller/SRF Phas-Locked Loop/Constant1'
   *  Sum : 'LaunchPad/Controller/SRF Phas-Locked Loop/PLL\nPI Regulator/Sum'
   *  Gain : 'LaunchPad/Controller/SRF Phas-Locked Loop/PLL\nPI Regulator/Gain'
   */
  LaunchPad_B.Sum3 = 314.159265358979326 + ((2.29999999999999982*
    LaunchPad_B.abc_q_1) + LaunchPad_B.Integrator_3);

  /* Gain : 'LaunchPad/Controller/SRF Phas-Locked Loop/PLL\nPI Regulator/Gain2' */
  LaunchPad_B.Gain2 = 251.*LaunchPad_B.abc_q_1;

  /* Trigonometric Function : 'LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF9/Cos' */
  LaunchPad_B.Cos_4 = cos(LaunchPad_B.Integrator_i1);

  /* Trigonometric Function : 'LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF9/Sin' */
  LaunchPad_B.Sin_4 = sin(LaunchPad_B.Integrator_i1);

  /* Gain : 'LaunchPad/Controller/Alternating-Current Control/PI/d-axis\nPI Regulator/Gain2' */
  LaunchPad_B.Gain2_1 = 11014.*LaunchPad_B.Sum;

  /* Gain : 'LaunchPad/Controller/Alternating-Current Control/PI/q-axis\nPI Regulator1/Gain2' */
  LaunchPad_B.Gain2_2 = 11014.*LaunchPad_B.Sum2;
  if (LaunchPad_errorStatus) {
    return;
  }

  /* Update for Integrator : 'LaunchPad/Controller/Alternating-Current Control/PI/d-axis\nPI Regulator/Integrator' */
  LaunchPad_X.Integrator_1_prevReset = !!(LaunchPad_B.StateMachine[1]);

  /* Update for Integrator : 'LaunchPad/Controller/Alternating-Current Control/PI/q-axis\nPI Regulator1/Integrator' */
  LaunchPad_X.Integrator_2_prevReset = !!(LaunchPad_B.StateMachine[1]);

  /* Update for Integrator : 'LaunchPad/Controller/SRF Phas-Locked Loop/PLL\nPI Regulator/Integrator' */
  LaunchPad_X.Integrator_3_prevReset = !!(LaunchPad_B.StateMachine[0]);

  /* Derivatives for Integrator : 'LaunchPad/Controller/SRF Phas-Locked Loop/Integrator' */
  if (LaunchPad_B.CompareToConstant != 0) {
    LaunchPad_deriv[0] = 0;
  } else {
    LaunchPad_deriv[0] = LaunchPad_B.Sum3;
  }

  /* Derivatives for Transfer Function : 'LaunchPad/Controller/Alternating-Current Control/PI/VFF/LPF'
   * incorporates
   *  Function : 'LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF9/abc->d'
   *  Function : 'LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF9/abc->q'
   */
  LaunchPad_deriv[2] = 0.66666666666666663 * (((LaunchPad_B.Fcn3 *
    LaunchPad_B.Cos_4) + (LaunchPad_B.Fcn4 * ((-0.5 * LaunchPad_B.Cos_4) +
    (0.866025403784438597 * LaunchPad_B.Sin_4)))) + (LaunchPad_B.Fcn5 * ((-0.5 *
    LaunchPad_B.Cos_4) - (0.866025403784438597 * LaunchPad_B.Sin_4))))-
    3141.59265358979292*LaunchPad_X.LPF[0];
  LaunchPad_deriv[3] = 0.66666666666666663 * ((((-LaunchPad_B.Fcn3) *
    LaunchPad_B.Sin_4) + (LaunchPad_B.Fcn4 * ((0.5 * LaunchPad_B.Sin_4) +
    (0.866025403784438597 * LaunchPad_B.Cos_4)))) + (LaunchPad_B.Fcn5 * ((0.5 *
    LaunchPad_B.Sin_4) - (0.866025403784438597 * LaunchPad_B.Cos_4))))-
    3141.59265358979292*LaunchPad_X.LPF[1];

  /* Derivatives for Integrator : 'LaunchPad/Controller/Alternating-Current Control/PI/d-axis\nPI Regulator/Integrator' */
  if ((LaunchPad_X.Integrator_1_x >= 200. && LaunchPad_B.Gain2_1 > 0) ||
      (LaunchPad_X.Integrator_1_x <= -200. && LaunchPad_B.Gain2_1 < 0)) {
    LaunchPad_deriv[4] = 0;
  } else {
    LaunchPad_deriv[4] = LaunchPad_B.Gain2_1;
  }

  /* Derivatives for Integrator : 'LaunchPad/Controller/Alternating-Current Control/PI/q-axis\nPI Regulator1/Integrator' */
  if ((LaunchPad_X.Integrator_2_x >= 200. && LaunchPad_B.Gain2_2 > 0) ||
      (LaunchPad_X.Integrator_2_x <= -200. && LaunchPad_B.Gain2_2 < 0)) {
    LaunchPad_deriv[5] = 0;
  } else {
    LaunchPad_deriv[5] = LaunchPad_B.Gain2_2;
  }

  /* Derivatives for Integrator : 'LaunchPad/Controller/SRF Phas-Locked Loop/PLL\nPI Regulator/Integrator' */
  LaunchPad_deriv[1] = LaunchPad_B.Gain2;

  /* Update continuous states */
  LaunchPad_X.Integrator_x += 5.00000000000000024e-05*LaunchPad_deriv[0];
  LaunchPad_X.LPF[0] += 5.00000000000000024e-05*LaunchPad_deriv[2];
  LaunchPad_X.LPF[1] += 5.00000000000000024e-05*LaunchPad_deriv[3];
  LaunchPad_X.Integrator_1_x += 5.00000000000000024e-05*LaunchPad_deriv[4];
  LaunchPad_X.Integrator_2_x += 5.00000000000000024e-05*LaunchPad_deriv[5];
  LaunchPad_X.Integrator_3_x += 5.00000000000000024e-05*LaunchPad_deriv[1];
}

void LaunchPad_terminate()
{
}
