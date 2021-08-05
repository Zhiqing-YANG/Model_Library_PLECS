/*
 * Header file for: SM_Coder_FSM_PLL_ACC/Circuit/LaunchPad
 * Generated with : PLECS 4.4.5
 *                  TI2837xS 1.2
 * Generated on   : 5 Aug 2021 17:46:50
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
  double Integrator_x;                 /* /LaunchPad/Controller/SRF Phas-Locked Loop/Integrator */
  double LPF[2];                       /* /LaunchPad/Controller/Alternating-Current Control/PI/VFF/LPF */
  double StateMachine[5];              /* /LaunchPad/State Machine */
  double Integrator_1_x;               /* /LaunchPad/Controller/Alternating-Current Control/PI/d-axis PI Regulator/Integrator */
  bool Integrator_1_prevReset;         /* /LaunchPad/Controller/Alternating-Current Control/PI/d-axis PI Regulator/Integrator */
  double Integrator_2_x;               /* /LaunchPad/Controller/Alternating-Current Control/PI/q-axis PI Regulator1/Integrator */
  bool Integrator_2_prevReset;         /* /LaunchPad/Controller/Alternating-Current Control/PI/q-axis PI Regulator1/Integrator */
  double Integrator_3_x;               /* /LaunchPad/Controller/SRF Phas-Locked Loop/PLL PI Regulator/Integrator */
  bool Integrator_3_prevReset;         /* /LaunchPad/Controller/SRF Phas-Locked Loop/PLL PI Regulator/Integrator */
} LaunchPad_ModelStates;

extern LaunchPad_ModelStates LaunchPad_X;

/* Block outputs */
typedef struct {
  double Saturation;                   /* /LaunchPad/ADC Decode/Saturation */
  double StateMachine[8];              /* /LaunchPad/State Machine */
  double Saturation_1[3];              /* /LaunchPad/Controller/Alternating-Current Control/PI/Saturation */
  double Fcn;                          /* /LaunchPad/ADC Decode/Calibration/With calibration/Fcn */
  double Integrator;                   /* /LaunchPad/Controller/SRF Phas-Locked Loop/Integrator */
  bool CompareToConstant;              /* /LaunchPad/Controller/SRF Phas-Locked Loop/Compare to Constant */
  double Integrator_i1;                /* /LaunchPad/Controller/SRF Phas-Locked Loop/Integrator */
  double Cos;                          /* /LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF7/Cos */
  double Fcn1;                         /* /LaunchPad/ADC Decode/Calibration/With calibration/Fcn1 */
  double Sin;                          /* /LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF7/Sin */
  double Fcn2;                         /* /LaunchPad/ADC Decode/Calibration/With calibration/Fcn2 */
  double abc_d;                        /* /LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF7/abc->d */
  double Sum;                          /* /LaunchPad/Controller/Alternating-Current Control/PI/Sum */
  double abc_q;                        /* /LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF7/abc->q */
  double Sum2;                         /* /LaunchPad/Controller/Alternating-Current Control/PI/Sum2 */
  double LPF[2];                       /* /LaunchPad/Controller/Alternating-Current Control/PI/VFF/LPF */
  double SW_OLPLL;                     /* /LaunchPad/SW_OLPLL */
  double SW_ACC;                       /* /LaunchPad/SW_ACC */
  double Fcn3;                         /* /LaunchPad/ADC Decode/Calibration/With calibration/Fcn3 */
  double Fcn4;                         /* /LaunchPad/ADC Decode/Calibration/With calibration/Fcn4 */
  double Fcn5;                         /* /LaunchPad/ADC Decode/Calibration/With calibration/Fcn5 */
  double Integrator_1;                 /* /LaunchPad/Controller/Alternating-Current Control/PI/d-axis PI Regulator/Integrator */
  double Sum7;                         /* /LaunchPad/Controller/Alternating-Current Control/PI/Sum7 */
  double Cos_1;                        /* /LaunchPad/Controller/Alternating-Current Control/PI/RRF->3ph/Cos */
  double Integrator_2;                 /* /LaunchPad/Controller/Alternating-Current Control/PI/q-axis PI Regulator1/Integrator */
  double Sum8;                         /* /LaunchPad/Controller/Alternating-Current Control/PI/Sum8 */
  double Sin_1;                        /* /LaunchPad/Controller/Alternating-Current Control/PI/RRF->3ph/Sin */
  double dq_a;                         /* /LaunchPad/Controller/Alternating-Current Control/PI/RRF->3ph/dq->a */
  double dq_b;                         /* /LaunchPad/Controller/Alternating-Current Control/PI/RRF->3ph/dq->b */
  double Gain3[3];                     /* /LaunchPad/Controller/Alternating-Current Control/PI/Gain3 */
  double Cos_2;                        /* /LaunchPad/Controller/OL/RRF->3ph/Cos */
  double Sin_2;                        /* /LaunchPad/Controller/OL/RRF->3ph/Sin */
  double dq_a_1;                       /* /LaunchPad/Controller/OL/RRF->3ph/dq->a */
  double dq_b_1;                       /* /LaunchPad/Controller/OL/RRF->3ph/dq->b */
  bool Switch;                         /* /LaunchPad/Controller/output selector/Switch */
  bool Switch1;                        /* /LaunchPad/Controller/output selector/Switch1 */
  double Sin_3;                        /* /LaunchPad/Controller/SRF Phas-Locked Loop/3ph->RRF/Sin */
  double Cos_3;                        /* /LaunchPad/Controller/SRF Phas-Locked Loop/3ph->RRF/Cos */
  double abc_q_1;                      /* /LaunchPad/Controller/SRF Phas-Locked Loop/3ph->RRF/abc->q */
  double Integrator_3;                 /* /LaunchPad/Controller/SRF Phas-Locked Loop/PLL PI Regulator/Integrator */
  double Sum3;                         /* /LaunchPad/Controller/SRF Phas-Locked Loop/Sum3 */
  double Gain2;                        /* /LaunchPad/Controller/SRF Phas-Locked Loop/PLL PI Regulator/Gain2 */
  double Cos_4;                        /* /LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF9/Cos */
  double Sin_4;                        /* /LaunchPad/Controller/Alternating-Current Control/PI/3ph->RRF9/Sin */
  double Gain2_1;                      /* /LaunchPad/Controller/Alternating-Current Control/PI/d-axis PI Regulator/Gain2 */
  double Gain2_2;                      /* /LaunchPad/Controller/Alternating-Current Control/PI/q-axis PI Regulator1/Gain2 */
} LaunchPad_BlockOutputs;

extern LaunchPad_BlockOutputs LaunchPad_B;

/* Entry point functions */
void LaunchPad_initialize(double time);
void LaunchPad_step(void);
void LaunchPad_terminate(void);

#endif                                 /* PLECS_HEADER_LaunchPad_h_ */
