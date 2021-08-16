/*
 * Implementation file for: SM_Coder_FSM_PLL_ACC/ Three-Phase 2L Grid-Tied  Inverter/LaunchPad
 * Generated with         : PLECS 4.4.5
 *                          TI2837xS 1.2
 * Generated on           : 16 Aug 2021 12:33:33
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
  "ad89deeda55307d729aa1607ffb11c2fe444518c";

/* Target declarations */
static DIO_Obj_t DoutDrvEnableObj;
static GDRV_Obj_t GdrvObj;
static GDRV_Handle_t GdrvHandle;
void LaunchPad_background(void)
{
  static int task = 0;
  switch (task){
   case 0:                             /* Powerstage protection */
    {
      PWR_background();
    }
    break;

   default:
    break;
  }

  task++;
  if (task >= 1) {
    task = 0;
  }
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

  {
    // gate-driver and protections
    GdrvHandle = GDRV_init(&GdrvObj,sizeof(GdrvObj));
    DIO_Handle_t dioHandle = DIO_init(&DoutDrvEnableObj,sizeof(DoutDrvEnableObj));
    DIO_configureOut(dioHandle, 25, false);
    GDRV_assignPin(GdrvHandle, GDRV_Pin_EnableOut, dioHandle,
                   GDRV_Pin_ActiveHigh);
    GDRV_powerup(GdrvHandle);
    PWR_configure(GdrvHandle, 20000);
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

    // force low when tripped
    params->reg.TZCTL.bit.TZA = 2;
    params->reg.TZCTL.bit.TZB = 2;
    HAL_setupPwm(0, 1, params);

    // configure deadtime to 1.000000e-07 seconds
    HAL_setPwmDeadtimeCounts(0, 4, 4);

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

    // force low when tripped
    params->reg.TZCTL.bit.TZA = 2;
    params->reg.TZCTL.bit.TZB = 2;
    HAL_setupPwm(1, 2, params);

    // configure deadtime to 1.000000e-07 seconds
    HAL_setPwmDeadtimeCounts(1, 4, 4);

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

    // force low when tripped
    params->reg.TZCTL.bit.TZA = 2;
    params->reg.TZCTL.bit.TZB = 2;
    HAL_setupPwm(2, 3, params);

    // configure deadtime to 1.000000e-07 seconds
    HAL_setPwmDeadtimeCounts(2, 4, 4);

    // PWM sequence starting with active state
    HAL_setPwmSequence(2, 1);
  }

  // configure ADC A
  {
    AIN_AdcParams_t *params = HAL_getDefaultAdcParams();
    HAL_setupAdc(2, 0, params);
  }

  // configure SOC0 of ADC-A to measure ADCIN0
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(2, 0, 0, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure ADC B
  {
    AIN_AdcParams_t *params = HAL_getDefaultAdcParams();
    HAL_setupAdc(0, 1, params);
  }

  // configure SOC0 of ADC-B to measure ADCIN2
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(0, 0, 2, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure SOC1 of ADC-B to measure ADCIN3
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(0, 1, 3, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure SOC2 of ADC-B to measure ADCIN4
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(0, 2, 4, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure SOC3 of ADC-B to measure ADCIN5
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(0, 3, 5, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure ADC C
  {
    AIN_AdcParams_t *params = HAL_getDefaultAdcParams();
    HAL_setupAdc(1, 2, params);
  }

  // configure SOC0 of ADC-C to measure ADCIN2
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(1, 0, 2, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure SOC1 of ADC-C to measure ADCIN3
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(1, 1, 3, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure SOC2 of ADC-C to measure ADCIN4
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(1, 2, 4, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure SOC3 of ADC-C to measure ADCIN5
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(1, 3, 5, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure ADC D
  {
    AIN_AdcParams_t *params = HAL_getDefaultAdcParams();
    HAL_setupAdc(3, 3, params);
  }

  // configure SOC0 of ADC-D to measure ADCIN0
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(3, 0, 0, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure SOC1 of ADC-D to measure ADCIN1
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(3, 1, 1, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure SOC2 of ADC-D to measure ADCIN2
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(3, 2, 2, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  // configure SOC3 of ADC-D to measure ADCIN3
  {
    AIN_ChannelParams_t *paramsChannel = HAL_getDefaultAinChannelParams();

    // set SOC trigger to PWM1
    paramsChannel->ADCSOCxCTL.bit.TRIGSEL = 5;
    paramsChannel->ADCSOCxCTL.bit.ACQPS = 14;
    HAL_setupAnalogInF(3, 3, 3, paramsChannel, 1.000000000e+00f,
                       0.000000000e+00f);
  }

  {
    static int taskId = 0;

    // Task 0 at 2.000000e+04 Hz
    DISPR_registerTask(0, &Tasks, 9500L, (void *)&taskId);
  }

  /* Initialization for Digital In : 'LaunchPad/SW_1' */
  HAL_setupDigitalIn(0, 95);

  /* Initialization for Delay : 'LaunchPad/Controller/Delay' */
  LaunchPad_X.Delay[0] = 0.;
  LaunchPad_X.Delay[1] = 0.;
  LaunchPad_X.Delay[2] = 0.;

  /* Initialization for Integrator : 'LaunchPad/Controller/Phase-Locked Loop/Integrator' */
  LaunchPad_X.Integrator_x = 0.;

  /* Initialization for Transfer Function : 'LaunchPad/Controller/Alternating-Current Control/PI/VFF/LPF' */
  LaunchPad_X.LPF[0] = 0.;
  LaunchPad_X.LPF[1] = 0.;

  /* Initialization for Digital In : 'LaunchPad/SW_9' */
  HAL_setupDigitalIn(1, 65);

  /* Initialization for Digital In : 'LaunchPad/SW_2' */
  HAL_setupDigitalIn(2, 139);

  /* Initialization for Integrator : 'LaunchPad/Controller/Alternating-Current Control/PI/d-axis\nPI Regulator/Integrator' */
  LaunchPad_X.Integrator_1_x = 0.;

  /* Initialization for Integrator : 'LaunchPad/Controller/Alternating-Current Control/PI/q-axis\nPI Regulator/Integrator' */
  LaunchPad_X.Integrator_2_x = 0.;

  /* Initialization for Digital In : 'LaunchPad/SW_8' */
  HAL_setupDigitalIn(3, 52);

  /* Initialization for State Machine : 'LaunchPad/State Machine' */
  {
    static const double* fsm_inputPtrs[] = { &LaunchPad_B.SW_1,
      &LaunchPad_B.SW_1, &LaunchPad_B.SW_2, &LaunchPad_B.SW_2,
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

  /* Initialization for Digital Out : 'LaunchPad/State_Units0' */
  HAL_setupDigitalOut(0, 130, false);

  /* Initialization for Digital Out : 'LaunchPad/State_Units1' */
  HAL_setupDigitalOut(1, 131, false);

  /* Initialization for Digital Out : 'LaunchPad/State_Units2' */
  HAL_setupDigitalOut(2, 66, false);

  /* Initialization for Digital Out : 'LaunchPad/State_Units3' */
  HAL_setupDigitalOut(3, 16, false);

  /* Initialization for Digital In : 'LaunchPad/SW_3' */
  HAL_setupDigitalIn(4, 56);

  /* Initialization for Digital In : 'LaunchPad/SW_4' */
  HAL_setupDigitalIn(5, 97);

  /* Initialization for Digital In : 'LaunchPad/SW_5' */
  HAL_setupDigitalIn(6, 94);

  /* Initialization for Digital In : 'LaunchPad/SW_6' */
  HAL_setupDigitalIn(7, 15);

  /* Initialization for Digital In : 'LaunchPad/SW_7' */
  HAL_setupDigitalIn(8, 14);

  /* Initialization for Digital Out : 'LaunchPad/Contactor' */
  HAL_setupDigitalOut(4, 19, false);

  /* Initialization for Digital Out : 'LaunchPad/LED Red' */
  HAL_setupDigitalOut(5, 34, false);

  /* Initialization for Digital Out : 'LaunchPad/LED Blue' */
  HAL_setupDigitalOut(6, 31, false);

  /* Initialization for Integrator : 'LaunchPad/Controller/Phase-Locked Loop/PLL\nPI Regulator/Integrator' */
  LaunchPad_X.Integrator_3_x = 0.;
}

void LaunchPad_step()
{
  if (LaunchPad_errorStatus) {
    return;
  }

  /* Digital In : 'LaunchPad/SW_1' */
  LaunchPad_B.SW_1 = HAL_getDigitalIn(0);

  /* Delay : 'LaunchPad/Controller/Delay' */
  LaunchPad_B.Delay[0] = LaunchPad_X.Delay[0];
  LaunchPad_B.Delay[1] = LaunchPad_X.Delay[1];
  LaunchPad_B.Delay[2] = LaunchPad_X.Delay[2];

  /* Integrator : 'LaunchPad/Controller/Phase-Locked Loop/Integrator' */
  LaunchPad_B.Integrator = LaunchPad_X.Integrator_x;

  /* Compare to Constant : 'LaunchPad/Controller/Phase-Locked Loop/Compare to\nConstant' */
  LaunchPad_B.CompareToConstant = LaunchPad_B.Integrator >= 6.28318530717958623;

  /* Integrator : 'LaunchPad/Controller/Phase-Locked Loop/Integrator' */
  if ((LaunchPad_B.CompareToConstant != 0)) {
    LaunchPad_X.Integrator_x = 0.;
  }

  LaunchPad_B.Integrator_i1 = LaunchPad_X.Integrator_x;

  /* Trigonometric Function : 'LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF8/Cos' */
  LaunchPad_B.Cos = cos(LaunchPad_B.Integrator_i1);

  /* Trigonometric Function : 'LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF8/Sin' */
  LaunchPad_B.Sin = sin(LaunchPad_B.Integrator_i1);

  /* Signal Switch : 'LaunchPad/Controller/Alternating-Current Control/PI/Switch'
   * incorporates
   *  Digital In : 'LaunchPad/SW_9'
   */
  LaunchPad_B.Switch = (HAL_getDigitalIn(1)) != 0.;

  /* Saturation : 'LaunchPad/ADC Decode/Saturation'
   * incorporates
   *  Gain : 'LaunchPad/ADC Decode/Gain'
   *  ADC : 'LaunchPad/ADC C'
   */
  LaunchPad_B.Saturation = 6.*(HAL_getAnalogInF(1, 0));
  if (LaunchPad_B.Saturation > 25.) {
    LaunchPad_B.Saturation = 25.;
  } else if (LaunchPad_B.Saturation < 0.) {
    LaunchPad_B.Saturation = 0.;
  }

  /* Function : 'LaunchPad/ADC Decode/Calibration I_ac/Fcn'
   * incorporates
   *  Function : 'LaunchPad/ADC Decode/Calibration I_ac/Fcn3'
   *  ADC : 'LaunchPad/ADC B'
   */
  LaunchPad_B.Fcn = ((((HAL_getAnalogInF(0, 1)) - -0.00700000000000000015) / 1.)
                     - 1.49700000000000011) / 0.0704700000000000049;

  /* Trigonometric Function : 'LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF7/Cos' */
  LaunchPad_B.Cos_1 = cos(LaunchPad_B.Integrator_i1);

  /* Function : 'LaunchPad/ADC Decode/Calibration I_ac/Fcn1'
   * incorporates
   *  Function : 'LaunchPad/ADC Decode/Calibration I_ac/Fcn4'
   *  ADC : 'LaunchPad/ADC B'
   */
  LaunchPad_B.Fcn1 = ((((HAL_getAnalogInF(0, 2)) - -0.0050000000000000001) / 1.)
                      - 1.49700000000000011) / 0.0704700000000000049;

  /* Trigonometric Function : 'LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF7/Sin' */
  LaunchPad_B.Sin_1 = sin(LaunchPad_B.Integrator_i1);

  /* Function : 'LaunchPad/ADC Decode/Calibration I_ac/Fcn2'
   * incorporates
   *  Function : 'LaunchPad/ADC Decode/Calibration I_ac/Fcn5'
   *  ADC : 'LaunchPad/ADC B'
   */
  LaunchPad_B.Fcn2 = ((((HAL_getAnalogInF(0, 3)) - -0.00300000000000000006) / 1.)
                      - 1.49700000000000011) / 0.0704700000000000049;

  /* Function : 'LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF7/abc->d' */
  LaunchPad_B.abc_d = 0.66666666666666663 * (((LaunchPad_B.Fcn *
    LaunchPad_B.Cos_1) + (LaunchPad_B.Fcn1 * ((-0.5 * LaunchPad_B.Cos_1) +
    (0.866025403784438597 * LaunchPad_B.Sin_1)))) + (LaunchPad_B.Fcn2 * ((-0.5 *
    LaunchPad_B.Cos_1) - (0.866025403784438597 * LaunchPad_B.Sin_1))));

  /* Sum : 'LaunchPad/Controller/Alternating-Current Control/PI/Sum' */
  LaunchPad_B.Sum = LaunchPad_B.Saturation - LaunchPad_B.abc_d;

  /* Digital In : 'LaunchPad/SW_2' */
  LaunchPad_B.SW_2 = HAL_getDigitalIn(2);

  /* Integrator : 'LaunchPad/Controller/Alternating-Current Control/PI/d-axis\nPI Regulator/Integrator' */
  if (((!LaunchPad_X.Integrator_1_prevReset && LaunchPad_B.SW_2) ||
       (LaunchPad_X.Integrator_1_prevReset && !LaunchPad_B.SW_2))) {
    LaunchPad_X.Integrator_1_x = 0.;
  }

  if (LaunchPad_X.Integrator_1_x > 200.) {
    LaunchPad_X.Integrator_1_x = 200.;
  } else if (LaunchPad_X.Integrator_1_x < -200.) {
    LaunchPad_X.Integrator_1_x = -200.;
  }

  LaunchPad_B.Integrator_1 = LaunchPad_X.Integrator_1_x;

  /* Function : 'LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF7/abc->q' */
  LaunchPad_B.abc_q = 0.66666666666666663 * ((((-LaunchPad_B.Fcn) *
    LaunchPad_B.Sin_1) + (LaunchPad_B.Fcn1 * ((0.5 * LaunchPad_B.Sin_1) +
    (0.866025403784438597 * LaunchPad_B.Cos_1)))) + (LaunchPad_B.Fcn2 * ((0.5 *
    LaunchPad_B.Sin_1) - (0.866025403784438597 * LaunchPad_B.Cos_1))));

  /* Sum : 'LaunchPad/Controller/Alternating-Current Control/PI/Sum9'
   * incorporates
   *  Gain : 'LaunchPad/Controller/Alternating-Current Control/PI/Gain5'
   *  Function : 'LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF8/abc->d'
   *  Subsystem : 'LaunchPad'
   *  Sum : 'LaunchPad/Controller/Alternating-Current Control/PI/Sum7'
   *  Signal Switch : 'LaunchPad/Controller/Alternating-Current Control/PI/Switch'
   *  Transfer Function : 'LaunchPad/Controller/Alternating-Current Control/PI/VFF/LPF'
   *  Sum : 'LaunchPad/Controller/Alternating-Current Control/PI/d-axis\nPI Regulator/Sum'
   *  Gain : 'LaunchPad/Controller/Alternating-Current Control/PI/d-axis\nPI Regulator/Gain'
   *  Gain : 'LaunchPad/Controller/Alternating-Current Control/PI/Gain'
   */
  LaunchPad_B.Sum9 = -(0.*(0.66666666666666663 * (((LaunchPad_UNCONNECTED *
    LaunchPad_B.Cos) + (LaunchPad_UNCONNECTED * ((-0.5 * LaunchPad_B.Cos) +
    (0.866025403784438597 * LaunchPad_B.Sin)))) + (LaunchPad_UNCONNECTED *
    ((-0.5 * LaunchPad_B.Cos) - (0.866025403784438597 * LaunchPad_B.Sin)))))) +
    ((LaunchPad_B.Switch ? (3141.59265358979292*LaunchPad_X.LPF[0]) :
      LaunchPad_UNCONNECTED) + ((15.5999999999999996*LaunchPad_B.Sum) +
      LaunchPad_B.Integrator_1) - (0.785398163397448279*LaunchPad_B.abc_q));

  /* Trigonometric Function : 'LaunchPad/Controller/Alternating-Current Control/PI/RRF->SRF/Cos' */
  LaunchPad_B.Cos_2 = cos(LaunchPad_B.Integrator_i1);

  /* Sum : 'LaunchPad/Controller/Alternating-Current Control/PI/Sum2'
   * incorporates
   *  Constant : 'LaunchPad/Controller/Constant'
   */
  LaunchPad_B.Sum2 = 0. - LaunchPad_B.abc_q;

  /* Integrator : 'LaunchPad/Controller/Alternating-Current Control/PI/q-axis\nPI Regulator/Integrator' */
  if (((!LaunchPad_X.Integrator_2_prevReset && LaunchPad_B.SW_2) ||
       (LaunchPad_X.Integrator_2_prevReset && !LaunchPad_B.SW_2))) {
    LaunchPad_X.Integrator_2_x = 0.;
  }

  if (LaunchPad_X.Integrator_2_x > 200.) {
    LaunchPad_X.Integrator_2_x = 200.;
  } else if (LaunchPad_X.Integrator_2_x < -200.) {
    LaunchPad_X.Integrator_2_x = -200.;
  }

  LaunchPad_B.Integrator_2 = LaunchPad_X.Integrator_2_x;

  /* Sum : 'LaunchPad/Controller/Alternating-Current Control/PI/Sum10'
   * incorporates
   *  Sum : 'LaunchPad/Controller/Alternating-Current Control/PI/Sum8'
   *  Gain : 'LaunchPad/Controller/Alternating-Current Control/PI/Gain2'
   *  Sum : 'LaunchPad/Controller/Alternating-Current Control/PI/q-axis\nPI Regulator/Sum'
   *  Gain : 'LaunchPad/Controller/Alternating-Current Control/PI/q-axis\nPI Regulator/Gain'
   *  Signal Switch : 'LaunchPad/Controller/Alternating-Current Control/PI/Switch'
   *  Transfer Function : 'LaunchPad/Controller/Alternating-Current Control/PI/VFF/LPF'
   *  Subsystem : 'LaunchPad'
   *  Gain : 'LaunchPad/Controller/Alternating-Current Control/PI/Gain6'
   *  Function : 'LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF8/abc->q'
   */
  LaunchPad_B.Sum10 = ((0.785398163397448279*LaunchPad_B.abc_d) +
                       ((15.5999999999999996*LaunchPad_B.Sum2) +
                        LaunchPad_B.Integrator_2) + (LaunchPad_B.Switch ?
    (3141.59265358979292*LaunchPad_X.LPF[1]) : LaunchPad_UNCONNECTED)) - (0.*
    (0.66666666666666663 * (((0. * LaunchPad_B.Sin) + (LaunchPad_UNCONNECTED *
    ((0.5 * LaunchPad_B.Sin) + (0.866025403784438597 * LaunchPad_B.Cos)))) +
    (LaunchPad_UNCONNECTED * ((0.5 * LaunchPad_B.Sin) - (0.866025403784438597 *
    LaunchPad_B.Cos))))));

  /* Trigonometric Function : 'LaunchPad/Controller/Alternating-Current Control/PI/RRF->SRF/Sin' */
  LaunchPad_B.Sin_2 = sin(LaunchPad_B.Integrator_i1);

  /* Function : 'LaunchPad/Controller/Alternating-Current Control/PI/RRF->SRF/dq->alpha' */
  LaunchPad_B.dq_alpha = (LaunchPad_B.Sum9 * LaunchPad_B.Cos_2) -
    (LaunchPad_B.Sum10 * LaunchPad_B.Sin_2);

  /* Function : 'LaunchPad/Controller/Alternating-Current Control/PI/RRF->SRF/dq->beta' */
  LaunchPad_B.dq_beta = (LaunchPad_B.Sum9 * LaunchPad_B.Sin_2) +
    (LaunchPad_B.Sum10 * LaunchPad_B.Cos_2);

  /* Function : 'LaunchPad/ADC Decode/Calibration V_dc/Fcn'
   * incorporates
   *  Function : 'LaunchPad/ADC Decode/Calibration V_dc/Fcn1'
   *  ADC : 'LaunchPad/ADC A'
   */
  LaunchPad_B.Fcn_1 = ((((HAL_getAnalogInF(2, 0)) - 0.) / 0.709999999999999964)
                       - 0.) / 0.00300000000000000006;

  /* Saturation : 'LaunchPad/Controller/Modulator/Saturation1'
   * incorporates
   *  Gain : 'LaunchPad/Controller/Modulator/Gain1'
   */
  LaunchPad_B.Saturation1 = 0.5*LaunchPad_B.Fcn_1;
  if (LaunchPad_B.Saturation1 < 1.) {
    LaunchPad_B.Saturation1 = 1.;
  }

  /* Trigonometric Function : 'LaunchPad/Controller/Modulator/RRF->3ph/Cos' */
  LaunchPad_B.Cos_3 = cos(LaunchPad_B.Integrator_i1);

  /* Trigonometric Function : 'LaunchPad/Controller/Modulator/RRF->3ph/Sin' */
  LaunchPad_B.Sin_3 = sin(LaunchPad_B.Integrator_i1);

  /* Function : 'LaunchPad/Controller/Modulator/RRF->3ph/dq->a'
   * incorporates
   *  Constant : 'LaunchPad/Controller/Modulator/m_ref_d'
   *  Constant : 'LaunchPad/Controller/Modulator/m_ref_q'
   */
  LaunchPad_B.dq_a = (0.905096679918780733 * LaunchPad_B.Cos_3) - (0. *
    LaunchPad_B.Sin_3);

  /* Function : 'LaunchPad/Controller/Modulator/RRF->3ph/dq->b'
   * incorporates
   *  Constant : 'LaunchPad/Controller/Modulator/m_ref_d'
   *  Constant : 'LaunchPad/Controller/Modulator/m_ref_q'
   */
  LaunchPad_B.dq_b = (0.905096679918780733 * ((-0.5 * LaunchPad_B.Cos_3) +
    (0.866025403784438597 * LaunchPad_B.Sin_3))) + (0. * ((0.5 *
    LaunchPad_B.Sin_3) + (0.866025403784438597 * LaunchPad_B.Cos_3)));

  /* Signal Switch : 'LaunchPad/Controller/Modulator/Switch' */
  LaunchPad_B.Switch_1 = LaunchPad_B.SW_2 != 0.;

  /* Saturation : 'LaunchPad/Controller/Modulator/Saturation'
   * incorporates
   *  Signal Switch : 'LaunchPad/Controller/Modulator/Switch'
   *  Product : 'LaunchPad/Controller/Modulator/Scale\nModulation\nIndex'
   *  Function : 'LaunchPad/Controller/Modulator/SRF->3ph/b'
   *  Function : 'LaunchPad/Controller/Modulator/SRF->3ph/c'
   *  Sum : 'LaunchPad/Controller/Modulator/RRF->3ph/Sum1'
   */
  LaunchPad_B.Saturation_1[0] = LaunchPad_B.Switch_1 ? (LaunchPad_B.dq_alpha /
    LaunchPad_B.Saturation1) : LaunchPad_B.dq_a;
  if (LaunchPad_B.Saturation_1[0] > 1.) {
    LaunchPad_B.Saturation_1[0] = 1.;
  } else if (LaunchPad_B.Saturation_1[0] < -1.) {
    LaunchPad_B.Saturation_1[0] = -1.;
  }

  LaunchPad_B.Saturation_1[1] = LaunchPad_B.Switch_1 ? ((0.5 *
    ((1.73205080756887719 * LaunchPad_B.dq_beta) - LaunchPad_B.dq_alpha)) /
    LaunchPad_B.Saturation1) : LaunchPad_B.dq_b;
  if (LaunchPad_B.Saturation_1[1] > 1.) {
    LaunchPad_B.Saturation_1[1] = 1.;
  } else if (LaunchPad_B.Saturation_1[1] < -1.) {
    LaunchPad_B.Saturation_1[1] = -1.;
  }

  LaunchPad_B.Saturation_1[2] = LaunchPad_B.Switch_1 ? ((-0.5 *
    (LaunchPad_B.dq_alpha + (1.73205080756887719 * LaunchPad_B.dq_beta))) /
    LaunchPad_B.Saturation1) : (-LaunchPad_B.dq_b - LaunchPad_B.dq_a);
  if (LaunchPad_B.Saturation_1[2] > 1.) {
    LaunchPad_B.Saturation_1[2] = 1.;
  } else if (LaunchPad_B.Saturation_1[2] < -1.) {
    LaunchPad_B.Saturation_1[2] = -1.;
  }

  /* Sum : 'LaunchPad/Controller/Modulator/[-1 1] -> [0 1]/Sum'
   * incorporates
   *  Gain : 'LaunchPad/Controller/Modulator/[-1 1] -> [0 1]/Gain'
   *  Constant : 'LaunchPad/Controller/Modulator/[-1 1] -> [0 1]/Constant'
   */
  LaunchPad_B.Sum_1[0] = (0.5*LaunchPad_B.Saturation_1[0]) + 0.5;
  LaunchPad_B.Sum_1[1] = (0.5*LaunchPad_B.Saturation_1[1]) + 0.5;
  LaunchPad_B.Sum_1[2] = (0.5*LaunchPad_B.Saturation_1[2]) + 0.5;

  /* Signal Switch : 'LaunchPad/Controller/Switch'
   * incorporates
   *  Digital In : 'LaunchPad/SW_8'
   */
  LaunchPad_B.Switch_2 = (HAL_getDigitalIn(3)) != 0.;

  /* PWM  : 'LaunchPad/PWM' */
  HAL_setPwmDuty(0, LaunchPad_B.Switch_2 ? LaunchPad_B.Delay[0] :
                 LaunchPad_B.Sum_1[0]);
  HAL_setPwmDuty(1, LaunchPad_B.Switch_2 ? LaunchPad_B.Delay[1] :
                 LaunchPad_B.Sum_1[1]);
  HAL_setPwmDuty(2, LaunchPad_B.Switch_2 ? LaunchPad_B.Delay[2] :
                 LaunchPad_B.Sum_1[2]);

  /* Function : 'LaunchPad/ADC Decode/Calibration V_ac/Fcn'
   * incorporates
   *  Function : 'LaunchPad/ADC Decode/Calibration V_ac/Fcn3'
   *  ADC : 'LaunchPad/ADC C'
   */
  LaunchPad_B.Fcn_2 = ((((HAL_getAnalogInF(1, 1)) - -0.00899999999999999932) /
                        1.) - 1.49700000000000011) / 0.00545113636363636286;

  /* Function : 'LaunchPad/ADC Decode/Calibration V_ac/Fcn1'
   * incorporates
   *  Function : 'LaunchPad/ADC Decode/Calibration V_ac/Fcn4'
   *  ADC : 'LaunchPad/ADC C'
   */
  LaunchPad_B.Fcn1_1 = ((((HAL_getAnalogInF(1, 2)) - -0.00600000000000000012) /
    1.) - 1.49700000000000011) / 0.00545113636363636286;

  /* Function : 'LaunchPad/ADC Decode/Calibration V_ac/Fcn2'
   * incorporates
   *  Function : 'LaunchPad/ADC Decode/Calibration V_ac/Fcn5'
   *  ADC : 'LaunchPad/ADC C'
   */
  LaunchPad_B.Fcn2_1 = ((((HAL_getAnalogInF(1, 3)) - 0.00400000000000000008) /
    1.) - 1.49700000000000011) / 0.00545113636363636286;

  /* State Machine : 'LaunchPad/State Machine' */
  LaunchPad_D_double[0] = ((fabs(LaunchPad_B.Fcn_2) >= 200.) || (fabs
    (LaunchPad_B.Fcn1_1) >= 200.) || (fabs(LaunchPad_B.Fcn2_1) >= 200.)) ||
    ((fabs(LaunchPad_B.Fcn) >= 25.) || (fabs(LaunchPad_B.Fcn1) >= 25.) || (fabs
      (LaunchPad_B.Fcn2) >= 25.)) || (fabs(LaunchPad_B.Fcn_1) >= 300.);
  LaunchPad_0_fsm_output(&LaunchPad_fsm_struct[0]);
  if (*LaunchPad_fsm_struct[0].fsm_errorStatus)
    LaunchPad_errorStatus = *LaunchPad_fsm_struct[0].fsm_errorStatus;

  /* Digital Out : 'LaunchPad/State_Units0' */
  HAL_setDigitalOut(0, LaunchPad_B.StateMachine[1]);

  /* Digital Out : 'LaunchPad/State_Units1' */
  HAL_setDigitalOut(1, LaunchPad_B.StateMachine[2]);

  /* Digital Out : 'LaunchPad/State_Units2' */
  HAL_setDigitalOut(2, LaunchPad_B.StateMachine[3]);

  /* Digital Out : 'LaunchPad/State_Units3' */
  HAL_setDigitalOut(3, LaunchPad_B.StateMachine[4]);

  /* Powerstage Protection : 'LaunchPad/Powerstage' */
  {
    if (LaunchPad_B.StateMachine[6] > 0) {
      HAL_enablePower(true);
    } else {
      HAL_enablePower(false);
    }

    PWR_fsm();
  }

  /* Digital Out : 'LaunchPad/Contactor' */
  HAL_setDigitalOut(4, LaunchPad_B.StateMachine[5]);

  /* Digital Out : 'LaunchPad/LED Red' */
  HAL_setDigitalOut(5, !LaunchPad_B.StateMachine[7]);

  /* Digital Out : 'LaunchPad/LED Blue' */
  HAL_setDigitalOut(6, !LaunchPad_B.StateMachine[6]);

  /* Trigonometric Function : 'LaunchPad/Controller/Phase-Locked Loop/3ph->RRF/Sin' */
  LaunchPad_B.Sin_4 = sin(LaunchPad_B.Integrator_i1);

  /* Trigonometric Function : 'LaunchPad/Controller/Phase-Locked Loop/3ph->RRF/Cos' */
  LaunchPad_B.Cos_4 = cos(LaunchPad_B.Integrator_i1);

  /* Function : 'LaunchPad/Controller/Phase-Locked Loop/3ph->RRF/abc->q' */
  LaunchPad_B.abc_q_1 = 0.66666666666666663 * ((((-LaunchPad_B.Fcn_2) *
    LaunchPad_B.Sin_4) + (LaunchPad_B.Fcn1_1 * ((0.5 * LaunchPad_B.Sin_4) +
    (0.866025403784438597 * LaunchPad_B.Cos_4)))) + (LaunchPad_B.Fcn2_1 * ((0.5 *
    LaunchPad_B.Sin_4) - (0.866025403784438597 * LaunchPad_B.Cos_4))));

  /* Integrator : 'LaunchPad/Controller/Phase-Locked Loop/PLL\nPI Regulator/Integrator' */
  if (((!LaunchPad_X.Integrator_3_prevReset && LaunchPad_B.SW_1) ||
       (LaunchPad_X.Integrator_3_prevReset && !LaunchPad_B.SW_1))) {
    LaunchPad_X.Integrator_3_x = 0.;
  }

  LaunchPad_B.Integrator_3 = LaunchPad_X.Integrator_3_x;

  /* Sum : 'LaunchPad/Controller/Phase-Locked Loop/Sum3'
   * incorporates
   *  Constant : 'LaunchPad/Controller/Phase-Locked Loop/Constant1'
   *  Sum : 'LaunchPad/Controller/Phase-Locked Loop/PLL\nPI Regulator/Sum'
   *  Gain : 'LaunchPad/Controller/Phase-Locked Loop/PLL\nPI Regulator/Gain'
   */
  LaunchPad_B.Sum3 = 314.159265358979326 + ((2.29999999999999982*
    LaunchPad_B.abc_q_1) + LaunchPad_B.Integrator_3);

  /* Gain : 'LaunchPad/Controller/Phase-Locked Loop/PLL\nPI Regulator/Gain2' */
  LaunchPad_B.Gain2 = 251.*LaunchPad_B.abc_q_1;

  /* Trigonometric Function : 'LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF9/Cos' */
  LaunchPad_B.Cos_5 = cos(LaunchPad_B.Integrator_i1);

  /* Trigonometric Function : 'LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF9/Sin' */
  LaunchPad_B.Sin_5 = sin(LaunchPad_B.Integrator_i1);

  /* Gain : 'LaunchPad/Controller/Alternating-Current Control/PI/d-axis\nPI Regulator/Gain2' */
  LaunchPad_B.Gain2_1 = 11014.*LaunchPad_B.Sum;

  /* Gain : 'LaunchPad/Controller/Alternating-Current Control/PI/q-axis\nPI Regulator/Gain2' */
  LaunchPad_B.Gain2_2 = 11014.*LaunchPad_B.Sum2;
  if (LaunchPad_errorStatus) {
    return;
  }

  /* Update for Delay : 'LaunchPad/Controller/Delay' */
  LaunchPad_X.Delay[0] = LaunchPad_B.Sum_1[0];
  LaunchPad_X.Delay[1] = LaunchPad_B.Sum_1[1];
  LaunchPad_X.Delay[2] = LaunchPad_B.Sum_1[2];

  /* Update for Integrator : 'LaunchPad/Controller/Alternating-Current Control/PI/d-axis\nPI Regulator/Integrator' */
  LaunchPad_X.Integrator_1_prevReset = !!(LaunchPad_B.SW_2);

  /* Update for Integrator : 'LaunchPad/Controller/Alternating-Current Control/PI/q-axis\nPI Regulator/Integrator' */
  LaunchPad_X.Integrator_2_prevReset = !!(LaunchPad_B.SW_2);

  /* Update for PWM  : 'LaunchPad/PWM' */
  PWR_syncEnableSwitching();

  /* Update for Integrator : 'LaunchPad/Controller/Phase-Locked Loop/PLL\nPI Regulator/Integrator' */
  LaunchPad_X.Integrator_3_prevReset = !!(LaunchPad_B.SW_1);

  /* Derivatives for Integrator : 'LaunchPad/Controller/Phase-Locked Loop/Integrator' */
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
  LaunchPad_deriv[2] = 0.66666666666666663 * (((LaunchPad_B.Fcn_2 *
    LaunchPad_B.Cos_5) + (LaunchPad_B.Fcn1_1 * ((-0.5 * LaunchPad_B.Cos_5) +
    (0.866025403784438597 * LaunchPad_B.Sin_5)))) + (LaunchPad_B.Fcn2_1 * ((-0.5
    * LaunchPad_B.Cos_5) - (0.866025403784438597 * LaunchPad_B.Sin_5))))-
    3141.59265358979292*LaunchPad_X.LPF[0];
  LaunchPad_deriv[3] = 0.66666666666666663 * ((((-LaunchPad_B.Fcn_2) *
    LaunchPad_B.Sin_5) + (LaunchPad_B.Fcn1_1 * ((0.5 * LaunchPad_B.Sin_5) +
    (0.866025403784438597 * LaunchPad_B.Cos_5)))) + (LaunchPad_B.Fcn2_1 * ((0.5 *
    LaunchPad_B.Sin_5) - (0.866025403784438597 * LaunchPad_B.Cos_5))))-
    3141.59265358979292*LaunchPad_X.LPF[1];

  /* Derivatives for Integrator : 'LaunchPad/Controller/Alternating-Current Control/PI/d-axis\nPI Regulator/Integrator' */
  if ((LaunchPad_X.Integrator_1_x >= 200. && LaunchPad_B.Gain2_1 > 0) ||
      (LaunchPad_X.Integrator_1_x <= -200. && LaunchPad_B.Gain2_1 < 0)) {
    LaunchPad_deriv[4] = 0;
  } else {
    LaunchPad_deriv[4] = LaunchPad_B.Gain2_1;
  }

  /* Derivatives for Integrator : 'LaunchPad/Controller/Alternating-Current Control/PI/q-axis\nPI Regulator/Integrator' */
  if ((LaunchPad_X.Integrator_2_x >= 200. && LaunchPad_B.Gain2_2 > 0) ||
      (LaunchPad_X.Integrator_2_x <= -200. && LaunchPad_B.Gain2_2 < 0)) {
    LaunchPad_deriv[5] = 0;
  } else {
    LaunchPad_deriv[5] = LaunchPad_B.Gain2_2;
  }

  /* Derivatives for Integrator : 'LaunchPad/Controller/Phase-Locked Loop/PLL\nPI Regulator/Integrator' */
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
