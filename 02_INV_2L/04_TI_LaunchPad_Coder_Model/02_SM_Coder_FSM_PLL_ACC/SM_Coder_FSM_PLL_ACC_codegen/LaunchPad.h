/*
 * Header file for: SM_Coder_FSM_PLL_ACC/ Three-Phase 2L Grid-Tied  Inverter/LaunchPad
 * Generated with : PLECS 4.4.5
 *                  TI2837xS 1.2
 * Generated on   : 13 Aug 2021 14:43:01
 */

#ifndef PLECS_HEADER_LaunchPad_h_
#define PLECS_HEADER_LaunchPad_h_
#include <stdbool.h>
#include <stdint.h>

/* Target declarations */
typedef int_fast8_t int8_t;
typedef uint_fast8_t uint8_t;
extern void LaunchPad_background(void);

/* Model floating point type */
typedef double LaunchPad_FloatType;

/* Model checksum */
extern const char * const LaunchPad_checksum;

/* Model error status */
extern const char * LaunchPad_errorStatus;

/* Model sample time */
extern const double LaunchPad_sampleTime;

/*
 * Model states */
typedef struct {
  double Delay[3];                     /* /LaunchPad/Controller/Delay */
  double Integrator_x;                 /* /LaunchPad/Controller/Phase-Locked Loop/Integrator */
  double LPF[2];                       /* /LaunchPad/Controller/Alternating-Current Control/PI/VFF/LPF */
  double Integrator_1_x;               /* /LaunchPad/Controller/Alternating-Current Control/PI/d-axis PI Regulator/Integrator */
  bool Integrator_1_prevReset;         /* /LaunchPad/Controller/Alternating-Current Control/PI/d-axis PI Regulator/Integrator */
  double Integrator_2_x;               /* /LaunchPad/Controller/Alternating-Current Control/PI/q-axis PI Regulator/Integrator */
  bool Integrator_2_prevReset;         /* /LaunchPad/Controller/Alternating-Current Control/PI/q-axis PI Regulator/Integrator */
  double StateMachine[5];              /* /LaunchPad/State Machine */
  double Integrator_3_x;               /* /LaunchPad/Controller/Phase-Locked Loop/PLL PI Regulator/Integrator */
  bool Integrator_3_prevReset;         /* /LaunchPad/Controller/Phase-Locked Loop/PLL PI Regulator/Integrator */
} LaunchPad_ModelStates;

extern LaunchPad_ModelStates LaunchPad_X;

/* Block outputs */
typedef struct {
  double Saturation;                   /* /LaunchPad/ADC Decode/Saturation */
  double Saturation1;                  /* /LaunchPad/Controller/Modulator/Saturation1 */
  double Saturation_1[3];              /* /LaunchPad/Controller/Modulator/Saturation */
  double StateMachine[6];              /* /LaunchPad/State Machine */
  double SW_1;                         /* /LaunchPad/SW_1 */
  double Delay[3];                     /* /LaunchPad/Controller/Delay */
  double Integrator;                   /* /LaunchPad/Controller/Phase-Locked Loop/Integrator */
  bool CompareToConstant;              /* /LaunchPad/Controller/Phase-Locked Loop/Compare to Constant */
  double Integrator_i1;                /* /LaunchPad/Controller/Phase-Locked Loop/Integrator */
  double Cos;                          /* /LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF8/Cos */
  double Sin;                          /* /LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF8/Sin */
  bool Switch;                         /* /LaunchPad/Controller/Alternating-Current Control/PI/Switch */
  double Fcn;                          /* /LaunchPad/ADC Decode/Calibration I_ac/Fcn */
  double Cos_1;                        /* /LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF7/Cos */
  double Fcn1;                         /* /LaunchPad/ADC Decode/Calibration I_ac/Fcn1 */
  double Sin_1;                        /* /LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF7/Sin */
  double Fcn2;                         /* /LaunchPad/ADC Decode/Calibration I_ac/Fcn2 */
  double abc_d;                        /* /LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF7/abc->d */
  double Sum;                          /* /LaunchPad/Controller/Alternating-Current Control/PI/Sum */
  double SW_2;                         /* /LaunchPad/SW_2 */
  double Integrator_1;                 /* /LaunchPad/Controller/Alternating-Current Control/PI/d-axis PI Regulator/Integrator */
  double abc_q;                        /* /LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF7/abc->q */
  double Sum9;                         /* /LaunchPad/Controller/Alternating-Current Control/PI/Sum9 */
  double Cos_2;                        /* /LaunchPad/Controller/Alternating-Current Control/PI/RRF->SRF/Cos */
  double Sum2;                         /* /LaunchPad/Controller/Alternating-Current Control/PI/Sum2 */
  double Integrator_2;                 /* /LaunchPad/Controller/Alternating-Current Control/PI/q-axis PI Regulator/Integrator */
  double Sum10;                        /* /LaunchPad/Controller/Alternating-Current Control/PI/Sum10 */
  double Sin_2;                        /* /LaunchPad/Controller/Alternating-Current Control/PI/RRF->SRF/Sin */
  double dq_alpha;                     /* /LaunchPad/Controller/Alternating-Current Control/PI/RRF->SRF/dq->alpha */
  double dq_beta;                      /* /LaunchPad/Controller/Alternating-Current Control/PI/RRF->SRF/dq->beta */
  double Fcn_1;                        /* /LaunchPad/ADC Decode/Calibration V_dc/Fcn */
  double Cos_3;                        /* /LaunchPad/Controller/Modulator/RRF->3ph/Cos */
  double Sin_3;                        /* /LaunchPad/Controller/Modulator/RRF->3ph/Sin */
  double dq_a;                         /* /LaunchPad/Controller/Modulator/RRF->3ph/dq->a */
  double dq_b;                         /* /LaunchPad/Controller/Modulator/RRF->3ph/dq->b */
  bool Switch_1;                       /* /LaunchPad/Controller/Modulator/Switch */
  double Sum_1[3];                     /* /LaunchPad/Controller/Modulator/[-1 1] -> [0 1]/Sum */
  bool Switch_2;                       /* /LaunchPad/Controller/Switch */
  double Fcn_2;                        /* /LaunchPad/ADC Decode/Calibration V_ac/Fcn */
  double Fcn1_1;                       /* /LaunchPad/ADC Decode/Calibration V_ac/Fcn1 */
  double Fcn2_1;                       /* /LaunchPad/ADC Decode/Calibration V_ac/Fcn2 */
  bool LogicalOperator5;               /* /LaunchPad/Protection/Logical Operator5 */
  double Sin_4;                        /* /LaunchPad/Controller/Phase-Locked Loop/3ph->RRF/Sin */
  double Cos_4;                        /* /LaunchPad/Controller/Phase-Locked Loop/3ph->RRF/Cos */
  double abc_q_1;                      /* /LaunchPad/Controller/Phase-Locked Loop/3ph->RRF/abc->q */
  double Integrator_3;                 /* /LaunchPad/Controller/Phase-Locked Loop/PLL PI Regulator/Integrator */
  double Sum3;                         /* /LaunchPad/Controller/Phase-Locked Loop/Sum3 */
  double Gain2;                        /* /LaunchPad/Controller/Phase-Locked Loop/PLL PI Regulator/Gain2 */
  double Cos_5;                        /* /LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF9/Cos */
  double Sin_5;                        /* /LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF9/Sin */
  double Gain2_1;                      /* /LaunchPad/Controller/Alternating-Current Control/PI/d-axis PI Regulator/Gain2 */
  double Gain2_2;                      /* /LaunchPad/Controller/Alternating-Current Control/PI/q-axis PI Regulator/Gain2 */
} LaunchPad_BlockOutputs;

extern LaunchPad_BlockOutputs LaunchPad_B;

/* Entry point functions */
void LaunchPad_initialize(double time);
void LaunchPad_step(void);
void LaunchPad_terminate(void);

#endif                                 /* PLECS_HEADER_LaunchPad_h_ */
